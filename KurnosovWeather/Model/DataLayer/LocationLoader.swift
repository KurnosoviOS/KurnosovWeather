//
//  LocationLoader.swift
//  KurnosovWeather
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

public class LocationLoader: NSObject, CLLocationManagerDelegate, LocationLoaderProtocol {
    public override init () {
        super.init()
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    private let locationManager = CLLocationManager()
    private let locationSubject = PublishSubject<AKLocation>()
    
    public func requestPermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestCoordinates() -> Observable<AKLocation> {
        self.locationManager.startUpdatingLocation()
        
        return self.locationSubject
    }
    
    
    // MARK:-------------CLLocationManagerDelegate-------------
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count < 1 {
            return
        }
        
        let location = AKLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        self.locationSubject.onNext(location)
        print("<--location-->didUpdateLocations: \(locations)")
        
        self.locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.locationSubject.onError(NSError(domain: "LocationLoader", code: 1, userInfo: [NSLocalizedDescriptionKey : "Permission for get location denied"]))
            break;
        default:
            break;
        }
    }
    
}
