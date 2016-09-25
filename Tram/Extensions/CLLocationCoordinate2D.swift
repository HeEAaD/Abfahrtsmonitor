//
//  CLLocationCoordinate2D.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let selfLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return location.distance(from: selfLocation)
    }
}
