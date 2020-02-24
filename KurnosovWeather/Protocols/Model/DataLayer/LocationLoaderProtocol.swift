//
//  LocationLoaderProtocol.swift
//  KurnosovWeather
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public protocol LocationLoaderProtocol {
    func requestPermission()
    func requestCoordinates() -> Observable<AKLocation>
}
 
public class MockLocationLoader: LocationLoaderProtocol {
    
    public init(permissionGranted: Bool) {
        self.permissionGranted = permissionGranted
    }
    
    private var permissionGranted: Bool
    
    public func requestPermission() {
        
    }
    
    public func requestCoordinates() -> Observable<AKLocation> {
        Observable<AKLocation>.create { (observer) -> Disposable in
            if self.permissionGranted {
                observer.on(.next(AKLocation(latitude: 56.8746, longitude: 60.5544)))
            }
            
            return Disposables.create()
        }
    }
}
