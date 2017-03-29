//
//  Scheduling.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 02/03/2017.
//  Copyright © 2017 usabilla. All rights reserved.
//

import Foundation


class Scheduling: NSObject, NSCoding {

    let activatingDate: Date?
    let deactivatingDate: Date?

    init(activatingDate: Date, deactivatingDate: Date) {
        self.activatingDate = activatingDate
        self.deactivatingDate = deactivatingDate
    }

    func isWithinScheduling(date: Date) -> Bool {
        return checkDates(date: date)
    }

    func isWithinScheduling() -> Bool {
        return checkDates(date: Date())
    }

    private func checkDates(date: Date) -> Bool {
        var isValid = true

        //Check if activation date has passed
        if let activate = activatingDate {
            if date < activate {
                isValid = false
            }
        }


        //Check if deactivation date is yet to pass
        if let deactivate = deactivatingDate {
            if date > deactivate {
                isValid = false
            }
        }

        return isValid
    }
    
    // MARK: NSCoding
    
    public required init?(coder aDecoder: NSCoder) {
        self.activatingDate = aDecoder.decodeObject(forKey: "activatingDate") as? Date
        self.deactivatingDate = aDecoder.decodeObject(forKey:"deactivatingDate") as? Date
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.activatingDate, forKey: "activatingDate")
        aCoder.encode(self.deactivatingDate, forKey: "deactivatingDate")
    }
    
}
