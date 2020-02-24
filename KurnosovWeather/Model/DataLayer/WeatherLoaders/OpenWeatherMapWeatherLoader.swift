//
//  WeatherLoader.swift
//  KurnosovWeather
//
//  Created by Admin on 13.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class OpenWeatherMapWeatherLoader: BaseWeatherLoader {
    
    public override init () {
        super.init()
    }
    
    private var _scheduler = ConcurrentDispatchQueueScheduler(qos: .utility)
    
    public override func httpServiceUrl(cityName: String) -> URL {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&lang=ru&appid=\(_httpServiceUserId)"
        
        return URL(string: urlString)!;
    }
    
    public override func httpServiceUrl(lat: Double, long: Double) -> URL {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&lang=ru&appid=\(_httpServiceUserId)"
        
        return URL(string: urlString)!;
    }
    
    private let _httpServiceUserId = "c0cae2f38b7d6c324a47eff0a57b1488"
    
    public override func getMeasurement(rawData: Any) throws -> AKWeatherMeasurement {
        if let rawDict = rawData as? NSDictionary {
            let cityName = (rawDict["name"] as? String) ?? ""
            
            let temperature = ((rawDict["main"] as? NSDictionary)?["temp"] as? Double) ?? 0.0
            
            return AKWeatherMeasurement(city: cityName, weather: AKWeather(temperature: temperature), date: Date())
        }
        else {
            throw NSError(domain: "OpenWeatherMapWeatherLoader", code: -1, userInfo: nil)
        }
    }
    
}
