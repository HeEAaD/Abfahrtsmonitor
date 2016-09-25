//
//  StopCache.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 24.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import Foundation
import CoreLocation

class StopCache {

    private enum Constants {
        static let maxResults = UInt(10)
        static let radius = CLLocationDistance(1000)
        static let archivedStopsKey = "archivedStops"
    }

    static var shared = StopCache()

    let defaults = UserDefaults.standard

    private var stops = [Stop]()

    init() {
        if let archivedStops = self.defaults.array(forKey: Constants.archivedStopsKey) as? [Data] {
            self.stops = archivedStops.flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) as? Stop }
        }
    }


    /// Fetches nearby stops.
    ///
    /// - parameter coordinate: The current location coordinate.
    /// - parameter completion: May be called multiple times.
    func stops(by coordinate: CLLocationCoordinate2D, completion: @escaping ([Stop]) -> Void) {
        guard CLLocationCoordinate2DIsValid(coordinate) else { return }

        let cachedStops = self.stops
            .filter { $0.distance(to: coordinate) <= Constants.radius }
            .sorted { l, r in l.distance(to: coordinate) < r.distance(to: coordinate) }

        completion(cachedStops)

        let url = StopCache.efaURL(coordinate: coordinate)
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if
                let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:AnyObject],
                let pins = json["pins"] as? [[String:AnyObject]]
            {
                let stops = pins
                    .flatMap({ Stop.stop(from: $0) })
                    .sorted { l, r in l.distance(to: coordinate) < r.distance(to: coordinate) }

                self?.cache(stops:stops)
                completion(stops)
            } else {
                print(">> \(error?.localizedDescription)")
                completion([])
            }
        }
        task.resume()
    }

    private static func efaURL(coordinate: CLLocationCoordinate2D) -> URL {
        let string = String(format: "http://efa.vvo-online.de:8080/standard/XML_COORD_REQUEST?coordOutputFormat=WGS84[DD.ddddd]&max=%d&inclFilter=1&radius_1=%.0f&type_1=STOP&outputFormat=JSON&coord=%f:%f:WGS84", Constants.maxResults, Constants.radius, coordinate.longitude, coordinate.latitude)
        if let url = URL(string: string) {
            return url
        } else {
            fatalError("Could not build URL")
        }
    }

    private func cache(stops: [Stop]) {

        for stop in stops where !self.stops.contains(stop) {
            self.stops.append(stop)
        }

        let archivedStops = self.stops.map { NSKeyedArchiver.archivedData(withRootObject: $0) }
        self.defaults.set(archivedStops, forKey: Constants.archivedStopsKey)
        self.defaults.synchronize()
    }
}

// MARK: - Persist stop
extension Stop {
    static var selectedStop: Stop? {
        get {
            if let archivedStop = UserDefaults.standard.object(forKey: "archivedSelectedStop") as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: archivedStop) as? Stop
            } else {
                return nil
            }
        }
        set {
            if let stop = newValue {
                let archivedStop = NSKeyedArchiver.archivedData(withRootObject: stop)
                UserDefaults.standard.set(archivedStop, forKey:"archivedSelectedStop")
            } else {
                UserDefaults.standard.set(nil, forKey:"archivedSelectedStop")
            }
            UserDefaults.standard.synchronize()
        }
    }
}

private extension Stop {
    static func stop(from json: [String:AnyObject]) -> Stop? {
        guard
            let id = json["id"] as? String,
            let name = json["desc"] as? String,
            let degrees = (json["coords"] as? String)?.components(separatedBy: ",").flatMap(CLLocationDegrees.init),
            degrees.count == 2
            else { return nil }


        let coordinate = CLLocationCoordinate2D(latitude:degrees[1], longitude: degrees[0])
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }

        return Stop(id: id, name: name, coordinate: coordinate)
    }
}
