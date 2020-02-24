//
//  CurrentWeatherViewModelProtocol.swift
//  KurnosovWeather
//
//  Created by Admin on 21.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public protocol CurrentWeatherViewModelProtocol {
    func onLoad()
    func reload()
    
    var currentCity: String { get }
    var currentWeather: String { get }
    
    var updateObservable: Observable<Void> { get }
}
