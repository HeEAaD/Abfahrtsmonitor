//
//  Stop+Network.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import Foundation
import CoreLocation

private extension Stop {
    init?(json: [String:AnyObject]) {
        guard
            let id = json["id"] as? String,
            let name = json["desc"] as? String,
            let degrees = (json["coords"] as? String)?.components(separatedBy: ",").flatMap(CLLocationDegrees.init),
            degrees.count == 2
            else { return nil }

        let coordinate = CLLocationCoordinate2D(latitude:degrees[1], longitude: degrees[0])
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }

        self.id = id
        self.name = name
        self.coordinate = coordinate
    }
}

public extension Stop {

    /// Fetches nearby stops.
    ///
    /// - parameter coordinate: The current location coordinate.
    /// - parameter completion: Nearby stops. Can be empty.
    public static func find(by coordinate: CLLocationCoordinate2D, completion: @escaping ([Stop]) -> Void) {

        let provider = Tram.nearestEfaProvider(from: coordinate)
        let url = provider.coordRequestUrl(with: coordinate)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if
                let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:AnyObject],
                let pins = json["pins"] as? [[String:AnyObject]]
            {
                let stops = pins
                    .flatMap { Stop(json: $0) }
                    .sorted { l, r in l.coordinate.distance(from: coordinate) < r.coordinate.distance(from: coordinate) }

                completion(stops)
            } else {
                completion([])
            }
        }
        task.resume()
    }
}
