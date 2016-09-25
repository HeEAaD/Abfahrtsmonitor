//
//  EfaProvider_TestCase.swift
//  Tram
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import XCTest
import Foundation
@testable import Tram

class EfaProvider_TestCase: XCTestCase {
    
    func test_all() {
        XCTAssertEqual(EfaProvider.all.count, 2)
        XCTAssert(EfaProvider.all.contains(.vvo))
        XCTAssert(EfaProvider.all.contains(.gvh))
    }
    
    func test_coordBaseURL_vvo() {
        XCTAssertEqual(EfaProvider.vvo.coordBaseURL.absoluteString, "http://efa.vvo-online.de:8080/standard/XML_COORD_REQUEST")
    }
 
    func test_coordBaseURL_gvh() {
        XCTAssertEqual(EfaProvider.gvh.coordBaseURL.absoluteString, "http://efa155.efa.de/efaws2/default/XML_COORD_REQUEST?mId=efa_www")
    }
}
