//
//  DepartureRow.swift
//  Abfahrtmonitor
//
//  Created by Steffen Matthischke on 23.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import WatchKit

class DepartureRow: NSObject {

    @IBOutlet var lineLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    @IBOutlet var timerLabel: WKInterfaceTimer!

    func update(with departure: Departure) {
        self.lineLabel.setText(departure.line)
        self.destinationLabel.setText(departure.destination)
        self.timerLabel.setDate(departure.date)
        self.timerLabel.start()
    }
}