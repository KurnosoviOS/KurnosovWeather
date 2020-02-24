//
//  WeatherbitWeatherLoader.swift
//  KurnosovWeather
//
//  Created by Admin on 24.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation
import RxSwift

public class WeatherbitWeatherLoader: BaseWeatherLoader {
    public override func httpServiceUrl(lat: Double, long: Double) -> URL {
        let urlString = "\(self._getBaseUrlString())&lat=\(lat)&lon=\(long)"
        return URL(string: urlString)!;
    }
    
    public override func httpServiceUrl(cityName: String) -> URL {
        let urlString = "\(self._getBaseUrlString())&city=\(cityName)"
        return URL(string: urlString)!;
    }
    
    public override func getMeasurement(rawData: Any) throws -> AKWeatherMeasurement {
        if let rawDict = rawData as? NSDictionary, let jsonDataArray = rawDict["data"] as? NSArray, jsonDataArray.count > 0, let jsonData = jsonDataArray[0] as? NSDictionary {
            let city = (jsonData["city_name"] as? String) ?? "unknown city"
            let temperature = (jsonData["temp"] as? Double) ?? 0.0
            
            var weather = AKWeather(temperature: temperature)
            
            if let windDescription = jsonData["wind_cdir_full"] as? String, let windSpeed = jsonData["wind_spd"] as? Double {
                let roundWindSpeed = Int(windSpeed.rounded())
                let windFullDescr = "\(windDescription), \(roundWindSpeed) м/с"
                
                weather.windDescription = windFullDescr
            }
            
            if let weatherDict = jsonData["weather"] as? NSDictionary, let weatherDescription = weatherDict["description"] as? String {
                weather.weatherDescription = weatherDescription
            }
            
            return AKWeatherMeasurement(city: city, weather: weather, date: Date())
        }
        else {
            throw NSError(domain: "WeatherbitWeatherLoader", code: -1, userInfo: nil)
        }
    }
    
    private let apiKey = "c0283fac83844c94b84cc90fc327694f"
    
    private func _getBaseUrlString() -> String {
        return "https://api.weatherbit.io/v2.0/current?key=\(self.apiKey)&lang=ru"
    }
}


/*
 {"data":[{"rh":87,"pod":"n","lon":60.55,"pres":969.694,"timezone":"Asia\/Yekaterinburg","ob_time":"2020-02-24 18:53","country_code":"RU","clouds":100,"ts":1582570386,"solar_rad":0,"state_code":"71","city_name":"Yekaterinburg","wind_spd":3.74138,"last_ob_time":"2020-02-24T18:33:00","wind_cdir_full":"Юго-Юго-Западный","wind_cdir":"ЮЮЗ","slp":1006.97,"vis":24.1351,"h_angle":-90,"sunset":"13:27","dni":0,"dewpt":-7,"snow":0,"uv":0,"precip":0,"wind_dir":194,"sunrise":"03:19","ghi":0,"dhi":0,"aqi":21,"lat":56.87,"weather":{"icon":"c04n","code":"804","description":"Облачно"},"datetime":"2020-02-24:18","temp":-5,"station":"E3995","elev_angle":-36.43,"app_temp":-11.2}],"count":1}
 */
