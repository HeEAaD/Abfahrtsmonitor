//
//  StopCache.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 24.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import Foundation
import CoreLocation
import Tram

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
            // TODO:
            self.stops = archivedStops.flatMap {
                if let cacheObject = NSKeyedUnarchiver.unarchiveObject(with: $0) as? StopCacheObject {
                    return Stop(cacheObject: cacheObject)
                }
                return nil
            }
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

        Tram.Stop.find(by: coordinate) { [weak self] stops in
            self?.cache(add:stops)
            completion(stops)
        }
    }

    private func cache(add stops: [Stop]) {
        
        for stop in stops where !self.stops.contains(stop) {
            self.stops.append(stop)
        }

        let archivedStops = self.stops.map { stop -> Data in
            let cacheObject = StopCacheObject(stop: stop)
            return NSKeyedArchiver.archivedData(withRootObject: cacheObject)
        }
        self.defaults.set(archivedStops, forKey: Constants.archivedStopsKey)
        self.defaults.synchronize()
    }
}

// MARK: - Persist stop
extension Stop {
    static var selectedStop: Stop? {
        get {
            if let archivedStop = UserDefaults.standard.object(forKey: "archivedSelectedStop") as? Data,
                let cacheObject = NSKeyedUnarchiver.unarchiveObject(with: archivedStop) as? StopCacheObject {
                return Stop(cacheObject: cacheObject)
            } else {
                return nil
            }
        }
        set {
            if let stop = newValue {
                let archivedStop = NSKeyedArchiver.archivedData(withRootObject: StopCacheObject(stop: stop))
                UserDefaults.standard.set(archivedStop, forKey:"archivedSelectedStop")
            } else {
                UserDefaults.standard.set(nil, forKey:"archivedSelectedStop")
            }
            UserDefaults.standard.synchronize()
        }
    }
}
