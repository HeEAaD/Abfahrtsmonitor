//
//  DepartueCache.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 24.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import Foundation
import Tram

class DepartueCache {
    static var shared = DepartueCache()

    private var cache =  [String:[Departure]]()

    func departures(stopId: String, completion: @escaping ([Departure]?) -> Void) {

        if let cachedDepartures = cache[stopId] {
            let departures = cachedDepartures.filter { $0.date.timeIntervalSinceNow > 60}
            completion(departures)
        }

        // TODO: find fast API
        guard let url = URL(string: "http://widgets.vvo-online.de/abfahrtsmonitor/Abfahrten.do/\(stopId)") else { fatalError("invalid URL") }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            var departures: [Departure]?
            if let data = data, let strings = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String]] {
                departures = strings.flatMap { Departure(strings:$0) }.sorted { $0.0.date < $0.1.date }
                self?.cache[stopId] = departures
            }
            completion(departures)
        }
        task.resume()
    }

}

private extension Departure {
    init?(strings: [String]) {
        guard strings.count == 3 else { return nil }

        self.line = strings[0]
        self.destination = strings[1]

        let secondsInCurrentMinute = TimeInterval(Calendar.current.component(.second, from: Date()))
        let timeInterval = (TimeInterval(strings[2]) ?? 0) * 60 - secondsInCurrentMinute
        self.date = Date(timeIntervalSinceNow: timeInterval)
    }
}
