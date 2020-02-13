//
//  WeatherLoaderTest.swift
//  KurnosovWeatherTests
//
//  Created by Admin on 13.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import XCTest
import KurnosovWeather
import RxSwift

class WeatherLoaderTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetLoader() {
        let loader = WeatherLoader().getWeatherLoader(city: "London")
        
        let disposeBag = DisposeBag()
        
        let resultExpect = XCTestExpectation(description: "waitForResult");
        
        loader.subscribe(onNext: { (result) in
            print("<--testGetLoader-->result: \(result)")
            if let dict = result as? NSDictionary {
                var test = 1
            }
            resultExpect.fulfill()
        }, onError: { (err) in
            print("<--testGetLoader-->error: \(err)")
        }, onCompleted: {
            print("<--testGetLoader-->completed")
        }) {
            print("<--testGetLoader-->disposed")
        }.disposed(by: disposeBag)
        
        self.wait(for: [resultExpect], timeout: 10.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
