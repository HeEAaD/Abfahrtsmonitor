//
//  EfaProvider_TestCase.swift
//  Tram
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Tram

class EfaProvider_TestCase: XCTestCase {

    let coordinate = CLLocationCoordinate2D(latitude: 50.1234, longitude: 12.3456)

    func test_url_vvo() {
        let url = VVOProvider().coordRequestUrl(with: coordinate)
        XCTAssertEqual(url.absoluteString, "http://efa.vvo-online.de:8080/standard/XML_COORD_REQUEST?coordOutputFormat=WGS84%5BDD.ddddd%5D&max=10&radius_1=1000&inclFilter=1&type_1=STOP&outputFormat=JSON&coord=12.345600:50.123400:WGS84")
    }

    func test_url_gvh() {
        let url = GVHProvider().coordRequestUrl(with: coordinate)
        XCTAssertEqual(url.absoluteString, "http://efa155.efa.de/efaws2/default/XML_COORD_REQUEST?mId=efa_www&coordOutputFormat=WGS84%5BDD.ddddd%5D&max=10&radius_1=1000&inclFilter=1&type_1=STOP&outputFormat=JSON&coord=12.345600:50.123400:WGS84")
    }

}

class EfaProvider_Tram_TestCase: XCTestCase {
    
    func test_allEfaProvider() {
        XCTAssertEqual(Tram.allEfaProvider.count, 3)
    }
    
    func test_nearestProvider_vvo() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 51.051128, longitude: 13.733356), // Dresden
            CLLocationCoordinate2D(latitude: 51.309113, longitude: 13.288223), // Riesa
            CLLocationCoordinate2D(latitude: 51.429976, longitude: 14.244799), // Hoyerswerda
        ]
        coordinates.forEach { XCTAssertEqual(Tram.nearestEfaProvider(from: $0).id, "VVO") }
    }

    func test_nearestProvider_gvh() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 52.387128, longitude: 9.735375), // Hannover
            CLLocationCoordinate2D(latitude: 52.573740, longitude: 9.720004), // Wedemark
            CLLocationCoordinate2D(latitude: 52.236957, longitude: 9.854880), // Sarstedt
        ]
        coordinates.forEach { XCTAssertEqual(Tram.nearestEfaProvider(from: $0).id, "GVH") }
    }
    
    func test_nearestProvider_mvv() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 48.144289, longitude: 11.570670) // Munich
        ]
        coordinates.forEach { XCTAssertEqual(Tram.nearestEfaProvider(from: $0).id, "MVV") }
    }
}
