//
//  StopCacheObject.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 23.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import Foundation
import CoreLocation
import Tram

class StopCacheObject: NSObject, NSCoding {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D

    init(stop: Stop) {
        self.id = stop.id
        self.name = stop.name
        self.coordinate = stop.coordinate
    }

    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {

        let latitude = aDecoder.decodeDouble(forKey: "latitude") as CLLocationDegrees
        let longitude = aDecoder.decodeDouble(forKey: "longitude") as CLLocationDegrees
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        guard
            let id = aDecoder.decodeObject(forKey: "id") as? String,
            let name = aDecoder.decodeObject(forKey: "name") as? String
            else { return nil }

        self.id = id
        self.name = name
        self.coordinate = coordinate
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.coordinate.latitude, forKey: "latitude")
        aCoder.encode(self.coordinate.longitude, forKey: "longitude")
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? Stop {
            return self.id == rhs.id
        }
        return false
    }
}

extension Stop {
    init(cacheObject: StopCacheObject) {
        self.id = cacheObject.id
        self.name = cacheObject.name
        self.coordinate = cacheObject.coordinate
    }
}
