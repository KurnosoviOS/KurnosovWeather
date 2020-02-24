//
//  WeatherLoaderProtocol.swift
//  KurnosovWeather
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public protocol WeatherLoaderProtocol {
    func loadCurrentWeatherByCity(_ city: String) -> Observable<AKWeatherMeasurement>
    func loadCurrentWeatherByLocation(_ location: AKLocation) -> Observable<AKWeatherMeasurement>
}

public class MockWeatherLoader: WeatherLoaderProtocol {
    public init (attempts: Int, requestDuration: TimeInterval) {
        self.attempts = attempts
        self.requestDuration = requestDuration
    }
    
    private var attempts: Int
    private var requestDuration: TimeInterval
    
    private var currentAttempt = 0;
    
    public func loadCurrentWeatherByCity(_ city: String) -> Observable<AKWeatherMeasurement> {
        return self._getMockLoader()
    }
    
    public func loadCurrentWeatherByLocation(_ location: AKLocation) -> Observable<AKWeatherMeasurement> {
        return self._getMockLoader()
    }
    
    private func _getMockLoader() -> Observable<AKWeatherMeasurement> {
        return Observable<AKWeatherMeasurement>.create { (observer) -> Disposable in
            DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + self.requestDuration) {
                self.currentAttempt += 1;
                if (self.currentAttempt % self.attempts == 0) {
                    let weather = AKWeather(temperature: -5.4)
                    let measurement = AKWeatherMeasurement(city: "Yekaterinburg", weather: weather, date: Date())
                    observer.onNext(measurement)
                }
                else {
                    observer.onError(NSError(domain: "MockWeatherLoader", code: -1, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
}
