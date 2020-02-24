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
        self.migrate()
    }
    
    private static var dbVersion: UInt64 = 1
    
    private func migrate() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: RealmDB.dbVersion,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
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
        self.weatherDescription = original.weather.weatherDescription
        self.windDescription = original.weather.windDescription
    }
    
    public func getMeasurement() -> AKWeatherMeasurement {
        var weather = AKWeather(temperature: self.temperature)
        
        if let weatherDescription = self.weatherDescription {
            weather.weatherDescription = weatherDescription
        }
        
        if let windDescription = self.windDescription {
            weather.windDescription = windDescription
        }
        
        return AKWeatherMeasurement(city: self.city, weather: weather, date: self.date)
    }
    
    @objc dynamic var city: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var temperature: Double = 0.0
    @objc dynamic var weatherDescription: String? = nil
    @objc dynamic var windDescription: String? = nil
    
    
}
