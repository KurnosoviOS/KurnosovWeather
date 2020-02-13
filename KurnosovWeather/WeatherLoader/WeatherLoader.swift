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

public class WeatherLoader {
    
    public init () {}
    
    private var _scheduler = ConcurrentDispatchQueueScheduler(qos: .utility)
    
    private static func _httpServiceUrl(cityName: String) -> URL {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(_httpServiceUserId)"
        
        return URL(string: urlString)!;
    }
    
    private static let _httpServiceUserId = "c0cae2f38b7d6c324a47eff0a57b1488"
    
    public func getWeatherLoader(city: String) -> Observable<Any> {
        return URLSession.shared.rx.json(url: WeatherLoader._httpServiceUrl(cityName: city))
            //.timeout(RxTimeInterval.milliseconds(2000), scheduler: _scheduler)
            //.subscribeOn(_scheduler)
    }
}
