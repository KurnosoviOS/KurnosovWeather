//
//  BaseWeatherLoader.swift
//  KurnosovWeather
//
//  Created by Admin on 25.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

open class BaseWeatherLoader: WeatherLoaderProtocol {
    public func httpServiceUrl(cityName: String) -> URL {
        fatalError("need override")
    }
    
    public func httpServiceUrl(lat: Double, long: Double) -> URL {
        fatalError("need override")
    }
    
    public func getCurrentWeatherByUrl(_ url: URL) -> Observable<AKWeatherMeasurement> {
        return URLSession.shared.rx.json(url: url)
            //.timeout(RxTimeInterval.milliseconds(2000), scheduler: _scheduler)
            //.subscribeOn(_scheduler)
            .map { (rawData) -> AKWeatherMeasurement in
                return try self.getMeasurement(rawData: rawData)
        }
    }
    
    public func getMeasurement(rawData: Any) throws -> AKWeatherMeasurement {
        fatalError("need override")
    }
    
    public func loadCurrentWeatherByCity(_ city: String) -> Observable<AKWeatherMeasurement> {
        return self.getCurrentWeatherByUrl(self.httpServiceUrl(cityName: city))
    }
    
    public func loadCurrentWeatherByLocation(_ location: AKLocation) -> Observable<AKWeatherMeasurement> {
        return self.getCurrentWeatherByUrl(self.httpServiceUrl(lat: location.latitude, long: location.longitude))
    }
}
