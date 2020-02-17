//
//  LocationManagerTests.swift
//  KurnosovWeatherTests
//
//  Created by Admin on 15.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import XCTest
@testable import KurnosovWeather

class LocationManagerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadCoordinates() {
        let locationLoader = LocationLoader()
        
        let locationExpectation = XCTestExpectation(description: "locationExpectation")
        
        locationLoader.requestPermission()
        
        locationLoader.requestCoordinates()
        
        self.wait(for: [locationExpectation], timeout: 10.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
