//
//  HistoryViewModelProtocol.swift
//  KurnosovWeather
//
//  Created by Admin on 24.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public protocol HistoryViewModelProtocol {
    func getHistoryItem(row: Int) -> HistoryCellViewState?
    func getHistoryCount() -> Int
    func reloadAll() -> Completable
    func clear() -> Completable
}

public class MockHistoryViewModel: HistoryViewModelProtocol {
    
    public init() {
        self.items.append(HistoryCellViewState(date: "2020-01-12 12:43", city: "Yekaterinburg", weatherDescription: "-12 C\nпеременная облачность\nветер 5 м/с"))
        self.items.append(HistoryCellViewState(date: "2020-01-12 13:24", city: "Yekaterinburg", weatherDescription: "-14 C\nясно\nветер 4 м/с"))
        self.items.append(HistoryCellViewState(date: "2020-01-12 23:43", city: "Yekaterinburg", weatherDescription: "-10 C\nснег\nветер 2 м/с"))
    }
    
    private var items: [HistoryCellViewState] = []
    
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
        return Completable.create { (onComplete) -> Disposable in
            onComplete(.completed)
            return Disposables.create()
        }
    }
    
    public func clear() -> Completable {
        return Completable.create { (onComplete) -> Disposable in
            self.items = []
            onComplete(.completed)
            return Disposables.create()
        }
    }
    
    
}
