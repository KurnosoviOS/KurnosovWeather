//
//  CurrenWeatherViewModel.swift
//  KurnosovWeather
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public class CurrenWeatherViewModel {
    
    public init (getWeatherInteractor: GetWeatherInteractorProtocol) {
        self._getWeatherInteractor = getWeatherInteractor
        #error("нужен лэйзи лоадинг")
        self.updateObservable = getWeatherInteractor.getWeatherObservable().subscribeOn(self._mainThreadScheduler).do(onNext: { (measurement) in
            
        })
    }
    
    private func _handleNextMeasurement(measurement: AKWeatherMeasurement) {
        #if DEBUG
        #warning("todo")
        //TODO: перевести названия городов
        #else
        #error("todo")
        #endif
        self.currentCity = measurement.city
        #if DEBUG
        #warning("todo")
        //TODO: исправить формат
        #else
        #error("todo")
        #endif
        
        #if DEBUG
        #warning("todo")
        //TODO: проверить цельсии/фаренгейты
        #else
        #error("todo")
        #endif
        self.currentWeather = "\(measurement.weather.temperature) C"
    }
    
    public func onLoad() {
        self._getWeatherInteractor.requestLocationPermission()
        self._getWeatherInteractor.requestWeather()
    }
    
    public func reload() {
        self._getWeatherInteractor.requestWeather()
    }
    
    public var currentCity = ""
    public var currentWeather = ""
    
    public var updateObservable: Observable<AKWeatherMeasurement>
    
    private var _mainThreadScheduler = MainScheduler()
    
    private var _getWeatherInteractor: GetWeatherInteractorProtocol
}
