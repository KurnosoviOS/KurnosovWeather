//
//  GetWeatherInteractorProtocol.swift
//  KurnosovWeather
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public protocol GetWeatherInteractorProtocol {
    func requestLocationPermission()
    func getWeatherObservable() -> Observable<WeatherMeasurementEvent>
    func getCityObservable() -> Observable<String>
    func requestWeather()
}
