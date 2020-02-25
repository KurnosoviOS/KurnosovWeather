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
    
    public init (weatherLoader: WeatherLoaderProtocol, locationLoader: LocationLoaderProtocol, db: DBProtocol, appStateHandler: AppStateHandlerProtocol) {
        self.weatherLoader = weatherLoader
        self.locationLoader = locationLoader
        self.db = db
        self.appStateHandler = appStateHandler
    }
    
    private let weatherLoader: WeatherLoaderProtocol
    private let locationLoader: LocationLoaderProtocol
    private let db: DBProtocol
    private let appStateHandler: AppStateHandlerProtocol
    
    private let weatherSubject = ReplaySubject<WeatherMeasurementEvent>.create(bufferSize: 1)
    
    private let citySubject = BehaviorSubject<String>(value: "Yekaterinburg")
    
    public func requestLocationPermission() {
        self.locationLoader.requestPermission()
    }
    
    public func getWeatherObservable() -> Observable<WeatherMeasurementEvent> {
        return weatherSubject
    }
    
    public func getCityObservable() -> Observable<String> {
        return citySubject
    }
    
    private var currentWeatherRequest: Disposable?
    
    public func requestWeather() {
        
        self._subscribeToAppState()
        
        //Не повторяем запросы
        if (self.currentWeatherRequest != nil) {
            return
        }
        
        print("<--eventChain-->interactor requestWeather")
        
        self.currentWeatherRequest = self.locationLoader.requestCoordinates().take(1).catchError({ (err) -> Observable<AKLocation> in
            //перебросим ошибку, заменив домен на внутренний
            try self._handleLocationError(error: err)
        }).flatMap { (location) -> Observable<AKWeatherMeasurement> in
            print("<--eventChain-->interactor getcoordinates")
            return self.weatherLoader.loadCurrentWeatherByLocation(location)
        }
        .do(onNext: { (measurement) in
            print("<--eventChain-->interactor onnext")
            self.weatherSubject.onNext(.success(measurement))
        }, onError: { (err) in
            let error = err as NSError
            
            print("<--eventChain-->interactor onerror \(error.domain)")
            //ошибки передаем как next, чтобы не завершить Observable
            
            //Если получили ошибку координат, выбросим её
            if (error.domain == "location") {
                self.weatherSubject.onNext(.error(error))
                return
            }
            
            if !self._repeatRequest() {
                self.weatherSubject.onNext(.error(error))
            }
        }, onCompleted: {
            print("<--eventChain-->interactor oncomplete")
        })
        .flatMap({ (measurement) -> Observable<Void> in
                return self.db.saveMeasurement(measurement).andThen(.just(Void()))
            })
        .subscribe({ (event) in
            self._requestCount = 0
                if let currentRequest = self.currentWeatherRequest {
                    currentRequest.dispose()
                    self.currentWeatherRequest = nil
                }
            })
          
    }
    
    private func _handleLocationError(error: Error) throws -> Observable<AKLocation> {
        throw NSError(domain: "location", code: 1, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription])
    }
    
    private var _requestCount = 0
    private let _maxRequestCount = 10
    
    private func _repeatRequest () -> Bool {
        self._requestCount += 1;
        //Не превысили ли лимит попыток?
        if (self._requestCount > self._maxRequestCount) {
            return false;
        }
        
        //повторим запрос
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0.2) {
            self.requestWeather()
        }

        return true
    }
    
    private let _disposeBag = DisposeBag()
    private var _wasSubscribedToAppState = false;
    
    private func _subscribeToAppState() {
        if (self._wasSubscribedToAppState) {
            return
        }
        self._wasSubscribedToAppState = true;
        
        self.appStateHandler.getAppStateObservable().subscribe { (event) in
            if let state = event.element, state == .active {
                self.requestWeather()
            }
        }.disposed(by: self._disposeBag)
    }
}
