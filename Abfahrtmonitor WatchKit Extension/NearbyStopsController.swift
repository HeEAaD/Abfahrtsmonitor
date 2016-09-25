//
//  InterfaceController.swift
//  Abfahrtmonitor WatchKit Extension
//
//  Created by Steffen Matthischke on 23.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import WatchKit
import Foundation
import Tram

class NearbyStopsController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!

    private var firstActivate = true

    private var stops = [Stop]()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
        self.setTitle("Neaby stops")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        if let selectedStop = Stop.selectedStop, firstActivate {
            self.pushController(withName: "DeparturesController", context: selectedStop)
        } else {
            Stop.selectedStop = nil
            self.startUpdatingLocation()
        }

        self.firstActivate = false
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()

        LocationManager.shared.stopUpdating()
    }

    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return stops[rowIndex]
    }

    private func startUpdatingLocation() {
        LocationManager.shared.startUpdating { [weak self] coordinate, error in
            switch (coordinate, error) {
            case let (coordinate?, _):
                self?.update(with: coordinate)
            case let (_, error?):
                print(">> error fetching location: \(error.localizedDescription)")
            default:
                break
            }
        }
    }

    private var lastLocation: CLLocationCoordinate2D? = nil

    private func update(with currentLocation: CLLocationCoordinate2D) {

        for rowIndex in 0..<self.table.numberOfRows {
            if let row = self.table.rowController(at: rowIndex) as? NearbyStopRow {
                row.currentCoordinate = currentLocation
            }
        }

        if let lastLocation = self.lastLocation, lastLocation.distance(from: currentLocation) < 50 {
            return
        }

        self.lastLocation = currentLocation

        StopCache.shared.stops(by: currentLocation) { [weak self] stops in
            self?.stops = stops
            self?.table.update(numberOfRows: stops.count, withRowType: "NearbyStopRow")

            for (i, stop) in stops.enumerated() {
                if let row = self?.table.rowController(at: i) as? NearbyStopRow {
                    row.currentCoordinate = currentLocation
                    row.stop = stop
                }
            }
        }

    }
}
