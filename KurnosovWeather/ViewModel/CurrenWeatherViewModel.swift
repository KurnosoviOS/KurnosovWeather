//
//  CurrenWeatherViewModel.swift
//  KurnosovWeather
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public class CurrentWeatherViewModel: CurrentWeatherViewModelProtocol {
    
    public init (getWeatherInteractor: GetWeatherInteractorProtocol) {
        self._getWeatherInteractor = getWeatherInteractor
    }
    
    private func _handleEvent(_ event: WeatherMeasurementEvent) {
        switch event {
        case .success(let measurement):
            self._handleNextMeasurement(measurement: measurement)
            break;
        default:
            break;
        }
    }
    
    private func _handleNextMeasurement(measurement: AKWeatherMeasurement) {
        //TODO: перевести названия городов
        self.currentCity = measurement.city
        
        let weather = measurement.weather
        
        var weatherText = "Температура: \(measurement.weather.temperature) °C"
        
        if let weatherDescr = weather.weatherDescription {
            weatherText += "\n\(weatherDescr)"
        }
        
        if let windDescr = weather.windDescription {
            weatherText += "\nВетер: \(windDescr)"
        }
        
        self.currentWeather = weatherText
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
    
    public lazy var updateObservable: Observable<CurrentWeatherViewState> = self._getWeatherInteractor.getWeatherObservable().observeOn(self._mainThreadScheduler).do(onNext: { (event) in
        self._handleEvent(event)
    }, onError: { err in
        print("<--eventChain-->viewModel error")
        throw err
    })
        .map { (event) -> CurrentWeatherViewState in
        print("<--eventChain-->viewModel event")
            switch event {
            case .success(let _):
                return .success
            case .error(let err):
                return.error(error: err)
            default:
                return .success
            }
            return .success
    }
    
    private var _mainThreadScheduler = MainScheduler()
    
    private var _getWeatherInteractor: GetWeatherInteractorProtocol
}
