//
//  GetWeatherInteractor.swift
//  KurnosovWeather
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public class GetWeatherInteractor: GetWeatherInteractorProtocol {
    
    public init (weatherLoader: WeatherLoaderProtocol, locationLoader: LocationLoaderProtocol, db: DBProtocol) {
        self.weatherLoader = weatherLoader
        self.locationLoader = locationLoader
        self.db = db
    }
    
    private let weatherLoader: WeatherLoaderProtocol
    private let locationLoader: LocationLoaderProtocol
    private let db: DBProtocol
    
    private let weatherSubject = ReplaySubject<AKWeatherMeasurement>.create(bufferSize: 1)
    
    private var noDistinctWeatherSubject: Observable<AKWeatherMeasurement> {
        return self.weatherSubject.distinctUntilChanged { (last, current) -> Bool in
            return current.date.compare(last.date) != .orderedSame
        }
    }
    
    private let citySubject = BehaviorSubject<String>(value: "Yekaterinburg")
    
    public func requestLocationPermission() {
        self.locationLoader.requestPermission()
    }
    
    public func getWeatherObservable() -> Observable<AKWeatherMeasurement> {
        return weatherSubject
    }
    
    public func getCityObservable() -> Observable<String> {
        return citySubject
    }
    
    private var currentWeatherRequest: Disposable?
    
    public func requestWeather() {
        
        //Не повторяем запросы
        if (self.currentWeatherRequest != nil) {
            return
        }
        
        self.currentWeatherRequest = self.locationLoader.requestCoordinates().take(1).flatMap { (location) -> Observable<AKWeatherMeasurement> in
            self.weatherLoader.loadCurrentWeatherByLocation(location)
        }
        .subscribe { (event) in
            self.weatherSubject.on(event)
            
            if let measurement = event.element {
                let _ = self.db.saveMeasurement(measurement)
                
                if let currentRequest = self.currentWeatherRequest {
                    currentRequest.dispose()
                    self.currentWeatherRequest = nil
                }
            }
            else {
                #if DEBUG
                #warning("todo")
                //TODO: Повторить запрос через интервал
                #else
                #error("todo")
                #endif
            }
        }
    }
    
    
}
