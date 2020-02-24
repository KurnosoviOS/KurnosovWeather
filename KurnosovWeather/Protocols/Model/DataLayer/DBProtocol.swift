//
//  DBProtocol.swift
//  KurnosovWeather
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public protocol DBProtocol {
    func saveMeasurement(_ measurement: AKWeatherMeasurement) -> Completable
    func getAllMeasurements() -> Single<[AKWeatherMeasurement]>
    func clear() -> Completable
}

public class MockDB: DBProtocol {
    
    public init () {}
    
    private var measurements: [AKWeatherMeasurement] = [];
    
    private let _dbScheduler = SerialDispatchQueueScheduler(qos: .utility)
    
    
    // MARK:-------------DBProtocol-------------
    
    public func saveMeasurement(_ measurement: AKWeatherMeasurement) -> Completable {
        return Completable.create { (onComplete) -> Disposable in
            self.measurements.append(measurement)
            onComplete(.completed)
            return Disposables.create()
        }.subscribeOn(self._dbScheduler)
    }
    
    public func getAllMeasurements() -> Single<[AKWeatherMeasurement]> {
        return Single<[AKWeatherMeasurement]>.create { (onNext) -> Disposable in
            onNext(.success(self.measurements))
            return Disposables.create()
        }.subscribeOn(self._dbScheduler)
    }
    
    public func clear() -> Completable {
        return Completable.create { (onComplete) -> Disposable in
            self.measurements = []
            onComplete(.completed)
            return Disposables.create()
        }.subscribeOn(self._dbScheduler)
    }
}
