//
//  CompositionRoot.swift
//  KurnosovWeather
//
//  Created by Admin on 21.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import Foundation

class CompositionRoot {
    
    public static var shared: CompositionRoot!
    
    public init () {
        self.createDependencies()
        CompositionRoot.shared = self
    }
    
    private var locationLoader: LocationLoaderProtocol!
    private var weatherLoader: WeatherLoaderProtocol!
    private var db: DBProtocol!
    
    private var getWeatherInteractor: GetWeatherInteractorProtocol!
    private var currentWeatherVM: CurrentWeatherViewModelProtocol!
    
    private var getHistoryInteractor: GetMeasurementHistoryInteractorProtocol!
    private var historyVM: HistoryViewModelProtocol!
    
    private func createDependencies() {
        locationLoader = LocationLoader()
        #if DEBUG
        #warning ("test")
        weatherLoader = MockWeatherLoader(attempts: 1, requestDuration: 0.1)
        #else
        #error ("test")
        #endif
        //weatherLoader = OpenWeatherMapWeatherLoader()
        db = MockDB()
        
        getWeatherInteractor = GetWeatherInteractor(weatherLoader: weatherLoader, locationLoader: locationLoader, db: db)
        currentWeatherVM = CurrentWeatherViewModel(getWeatherInteractor: getWeatherInteractor)
        
        getHistoryInteractor = GetMeasurementHistoryInteractor(db: db)
        historyVM = HistoryViewModel(interactor: getHistoryInteractor)
    }
    
    public func setDependencies(client: DependencyClient) {
        if let vc = client as? CurrentWeatherViewController {
            vc.viewModel = currentWeatherVM
        }
        else if let vc = client as? WeatherHistoryViewController {
            vc.viewModel = self.historyVM
        }
    }
}
