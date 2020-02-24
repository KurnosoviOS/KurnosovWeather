//
//  GetMeasurementHistoryInteractorProtocol.swift
//  KurnosovWeather
//
//  Created by Admin on 24.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public protocol GetMeasurementHistoryInteractorProtocol {
    func getHistory() -> Single<[AKWeatherMeasurement]>
    func clear() -> Completable
}
