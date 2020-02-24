//
//  AKWeather.swift
//  KurnosovWeather
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation

public struct AKWeather {
    public init (temperature: Double) {
        self.temperature = temperature
    }
    
    public var temperature: Double
    
    public var weatherDescription: String?
    public var windDescription: String?
    
}
