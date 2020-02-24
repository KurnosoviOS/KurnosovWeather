//
//  HistoryViewModel.swift
//  KurnosovWeather
//
//  Created by Admin on 24.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public class HistoryViewModel: HistoryViewModelProtocol {
    
    public init(interactor: GetMeasurementHistoryInteractorProtocol) {
        self._interactor = interactor
        self.dateFormatter.dateFormat = "dd.MM.yy hh:mm"
    }
    
    private let _interactor: GetMeasurementHistoryInteractorProtocol
    
    // MARK:-------------HistoryViewModelProtocol-------------
    
    public func getHistoryItem(row: Int) -> HistoryCellViewState? {
        if (row < self.items.count) {
            return self.items[row]
        }
        
        return nil
    }
    
    public func getHistoryCount() -> Int {
        return self.items.count
    }
    
    public func reloadAll() -> Completable {
        return self._interactor.getHistory().map { (measurements) -> Void in
            var states: [HistoryCellViewState] = []
            for measurement in measurements {
                let date = self.dateFormatter.string(from: measurement.date)
                let city = measurement.city
                let weatherDescription = "\(measurement.weather.temperature)"
                
                let state = HistoryCellViewState(date: date, city: city, weatherDescription: weatherDescription)
                
                states.append(state)
            }
            self.items = states
        }.asCompletable().observeOn(_mainScheduler)
    }
    
    public func clear() -> Completable {
        return self._interactor.clear().andThen(reloadAll()).observeOn(_mainScheduler)
    }
    
    private let _mainScheduler = MainScheduler()
    private var items: [HistoryCellViewState] = []
    private var reloadScheduler = SerialDispatchQueueScheduler(qos: .utility)
    private var dateFormatter = DateFormatter()
}
