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
        
        self.dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        self.dateFormatter.calendar = NSCalendar.current
        self.dateFormatter.timeZone = TimeZone.current
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
                var weatherDescription = "Температура \(measurement.weather.temperature) °C"
                
                var secondString = ""
                if let weatherDescr = measurement.weather.weatherDescription {
                    secondString = "\(weatherDescr)"
                }
                
                if let windDescr = measurement.weather.windDescription {
                    let wind = "ветер \(windDescr)"
                    secondString += (secondString.isEmpty) ? "\(wind)" : ", \(wind)"
                }
                
                if (!secondString.isEmpty) {
                    weatherDescription += "\n\(secondString)"
                }
                
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
