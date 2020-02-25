//
//  WeatherMeasurementEvent.swift
//  KurnosovWeather
//
//  Created by Admin on 25.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation

public enum WeatherMeasurementEvent {
    case success(_ result: AKWeatherMeasurement)
    case error(_ error: Error)
}
