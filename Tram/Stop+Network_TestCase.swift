//
//  Stop+Network_TestCase.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Tram

class Stop_Network_TestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: integration tests
    func test_find() {
        let coordinates = [
//            CLLocationCoordinate2D(latitude: 51.051128, longitude: 13.733356), // Dresden
            CLLocationCoordinate2D(latitude: 52.387128, longitude: 9.735375) // Hannover
        ]

        for coordinate in coordinates {
            let expectation = self.expectation(description: "")
            Stop.find(by: coordinate) { stops in
                XCTAssertFalse(stops.isEmpty)
                expectation.fulfill()
            }

            self.waitForExpectations(timeout: 5, handler: nil)
        }
    }
}
