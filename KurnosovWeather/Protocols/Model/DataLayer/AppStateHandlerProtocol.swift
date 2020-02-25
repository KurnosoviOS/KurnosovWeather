//
//  AppStateHandlerProtocol.swift
//  KurnosovWeather
//
//  Created by Admin on 25.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public protocol AppStateHandlerProtocol {
    func getAppStateObservable() -> Observable<UIApplication.State>
}

public class MockAppStateHandler: AppStateHandlerProtocol {
    public func getAppStateObservable() -> Observable<UIApplication.State> {
        Observable<UIApplication.State>.create { (observer) -> Disposable in
            
            observer.onNext(.active)
            
            return Disposables.create()
        }
    }
    
    
}
