//
//  RealmDB.swift
//  KurnosovWeather
//
//  Created by Admin on 21.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

public class RealmDB: DBProtocol {
    public init () {
        
    }
    
    public func saveMeasurement(_ measurement: AKWeatherMeasurement) -> Completable {
        return Completable.create { (onComplete) -> Disposable in
            let realm = try! Realm()
            
            let newDbObject = RealmWeatherMeasurement()
            newDbObject.copyFields(original: measurement)
            
            try! realm.write({
                realm.add(newDbObject)
            })
            
            onComplete(.completed)
            
            return Disposables.create()
        }.subscribeOn(self.scheduler)
        
    }
    
    public func getAllMeasurements() -> Single<[AKWeatherMeasurement]> {
        return Single.create { (event) -> Disposable in
            let realm = try! Realm()
            
            let measurementsRes = realm.objects(RealmWeatherMeasurement.self).sorted(byKeyPath: "date", ascending: false).map { (dbObject) -> AKWeatherMeasurement in
                return dbObject.getMeasurement()
            }
            
            let measurements = Array(measurementsRes)
            
            event(.success(measurements))
            
            return Disposables.create()
        }.subscribeOn(self.scheduler)
    }
    
    public func clear() -> Completable {
        return Completable.create { (onComplete) -> Disposable in
            let realm = try! Realm()
            
            try! realm.write({
                realm.deleteAll()
            })
            
            onComplete(.completed)
            return Disposables.create()
        }.subscribeOn(self.scheduler)
    }
    
    
    private var scheduler = SerialDispatchQueueScheduler(qos: .utility)
}

public class RealmWeatherMeasurement: Object {
    public func copyFields (original: AKWeatherMeasurement){
        self.city = original.city
        self.date = original.date
        self.temperature = original.weather.temperature
    }
    
    public func getMeasurement() -> AKWeatherMeasurement {
        let weather = AKWeather(temperature: self.temperature)
        return AKWeatherMeasurement(city: self.city, weather: weather, date: self.date)
    }
    
    @objc dynamic var city: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var temperature: Double = 0.0
    
}
