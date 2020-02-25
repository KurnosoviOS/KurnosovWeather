//
//  AppStateHandler.swift
//  KurnosovWeather
//
//  Created by Admin on 25.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public class AppStateHandler: AppStateHandlerProtocol {
    public init () {
        self.start()
    }
    
    private let appStateSubject = BehaviorSubject<UIApplication.State>(value: .active)
    
    public func getAppStateObservable() -> Observable<UIApplication.State> {
        return appStateSubject
    }
    
    public func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(onActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onInActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc public func onActive() {
        self.appStateSubject.onNext(.active)
    }
    
    @objc public func onInActive() {
        self.appStateSubject.onNext(.inactive)
    }
    
    @objc public func onBackground() {
        self.appStateSubject.onNext(.background)
    }
}
