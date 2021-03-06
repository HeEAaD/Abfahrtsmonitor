//
//  DeparturesController.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 23.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import WatchKit
import Tram

class DeparturesController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!

    private var departures = [Departure]() {
        didSet {

            self.table.update(numberOfRows: self.departures.count, withRowType: "DepartureRow")

            for (i, departue) in self.departures.enumerated() {
                if let row = self.table.rowController(at: i) as? DepartureRow {
                    row.update(with: departue)
                }
            }
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.

        if let stop = context as? Stop {
            Stop.selectedStop = stop
            self.setTitle("Loading…")

            DepartueCache.shared.departures(stopId: stop.id) { [weak self] departures in
                if let departures = departures {
                    self?.setTitle(stop.name)
                    self?.departures = departures
                } else {
                    self?.setTitle("Error")
                }
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension WKInterfaceTable {
    func update(numberOfRows: Int, withRowType rowType: String) {
        if self.numberOfRows == 0 {
            self.setNumberOfRows(numberOfRows, withRowType: rowType)
        } else {
            let rowDiff = self.numberOfRows - numberOfRows

            if rowDiff < 0 {
                self.insertRows(at: IndexSet(integersIn: 0..<abs(rowDiff)), withRowType: rowType)
            } else if rowDiff > 0 {
                self.removeRows(at: IndexSet(integersIn: 0..<rowDiff))
            }
        }
    }
}
