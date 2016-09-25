//
//  Stop.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import CoreLocation

public struct Stop {
    public let id: String
    public let name: String
    public let coordinate: CLLocationCoordinate2D
}

extension Stop: Equatable {
    public static func ==(lhs: Stop, rhs: Stop) -> Bool {
        return lhs.id == rhs.id
    }
}
