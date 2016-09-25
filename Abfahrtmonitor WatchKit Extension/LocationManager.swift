//
//  LocationManager.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 24.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import Foundation
import CoreLocation

typealias UpdateLocationBlock = (CLLocationCoordinate2D?, Error?) -> Void

class LocationManager: NSObject {
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    fileprivate var updateLocationBlock: UpdateLocationBlock? = nil
    func startUpdating(updateLocationBlock: @escaping UpdateLocationBlock) {

        self.updateLocationBlock = updateLocationBlock

        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()

        #if (arch(i386) || arch(x86_64)) // Simulator
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let coordinate = CLLocationCoordinate2D(latitude: 51.02, longitude: 13.768)
                self.updateLocationBlock?(coordinate, nil)
            }
        #endif
    }

    func stopUpdating() {
        self.locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.updateLocationBlock?(locations.first?.coordinate, nil)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if !(arch(i386) || arch(x86_64)) // Simulator
        self.updateLocationBlock?(nil, error)
        #endif
    }
}

extension CLLocationCoordinate2D {
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let selfLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return location.distance(from: selfLocation)
    }
}
