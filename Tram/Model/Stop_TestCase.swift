//
//  Stop_TestCase.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Tram

class Stop_TestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_equal() {
        let stopA = Stop(id: "1", name: "a", coordinate: CLLocationCoordinate2D(latitude: 1.1, longitude: 2.2))
        let stopB = Stop(id: "1", name: "b", coordinate: CLLocationCoordinate2D(latitude: 3.3, longitude: 4.4))
        XCTAssertEqual(stopA, stopB)
    }
    
    func test_not_equal() {
        let coordinate = CLLocationCoordinate2D(latitude: 1.1, longitude: 2.2)
        let stopA = Stop(id: "2", name: "a", coordinate: coordinate)
        let stopB = Stop(id: "1", name: "a", coordinate: coordinate)
        XCTAssertNotEqual(stopA, stopB)
    }
}
