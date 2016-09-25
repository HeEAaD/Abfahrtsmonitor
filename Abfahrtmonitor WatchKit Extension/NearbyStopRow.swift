//
//  NearbyStopRow.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 23.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import WatchKit
import Tram

class NearbyStopRow: NSObject {

    @IBOutlet private var distanceLabel: WKInterfaceLabel!
    @IBOutlet private var nameLabel: WKInterfaceLabel!

    var currentCoordinate: CLLocationCoordinate2D? = nil {
        didSet {
            self.updateDistanceLabel()
        }
    }

    var stop: Stop? = nil {
        didSet {
            if let stop = stop {
                self.nameLabel.setText(stop.name)
                self.updateDistanceLabel()
            }
        }
    }

    func updateDistanceLabel() {
        if
            let currentCoordinate = self.currentCoordinate,
            let distance = self.stop?.distance(to: currentCoordinate)
        {
            self.distanceLabel.setText(String(format: "%.0fm", distance))
        } else {
            self.distanceLabel.setText(" ")
        }
    }
}
