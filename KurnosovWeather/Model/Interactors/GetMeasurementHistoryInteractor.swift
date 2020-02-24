//
//  GetMeasurementHistoryInteractor.swift
//  KurnosovWeather
//
//  Created by Admin on 24.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

class GetMeasurementHistoryInteractor: GetMeasurementHistoryInteractorProtocol {
    
    public init (db: DBProtocol) {
        self._db = db
    }
    
    private var _db: DBProtocol
    
    
    // MARK:-------------GetMeasurementHistoryInteractorProtocol-------------
    
    func getHistory() -> Single<[AKWeatherMeasurement]> {
        return self._db.getAllMeasurements()
    }
    
    func clear() -> Completable {
        return self._db.clear()
    }
    
    
}
