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
        
        print("<--eventChain-->interactor requestWeather")
        
        self.currentWeatherRequest = self.locationLoader.requestCoordinates().take(1).flatMap { (location) -> Observable<AKWeatherMeasurement> in
            print("<--eventChain-->interactor getcoordinates")
            return self.weatherLoader.loadCurrentWeatherByLocation(location)
        }
        .do(onNext: { (measurement) in
            self.weatherSubject.onNext(measurement)
        }, onError: { (err) in
            self._repeatRequest()
        }, onCompleted: {
            
        })
        .flatMap({ (measurement) -> Observable<Void> in
                return self.db.saveMeasurement(measurement).andThen(.just(Void()))
            })
        .subscribe({ (event) in
                if let currentRequest = self.currentWeatherRequest {
                    currentRequest.dispose()
                    self.currentWeatherRequest = nil
                }
            })
          
    }
    
    private func _repeatRequest () {
        //повторим запрос
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0.2) {
            self.requestWeather()
        }

        //TODO: количество попыток, потом ошибка
    }
    
    #if DEBUG
    #warning("todo")
    //TODO: реагировать на выход из бэкграунда
    #else
    #error("todo")
    #endif
}
