//
//  PercentageDecorator.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 21/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

class PercentageDecorator: Decorator {

    var percentage: Int
    var diceAlreadyRolled: Bool
    var previousPercentage: Int

    init(percentage: Int, rule: Rule) {
        self.percentage = percentage
        self.diceAlreadyRolled = false
        self.previousPercentage = 1000  // just setting it til more than 100 == not set
        super.init(rule: rule)
    }

    required init?(json: JSON) {
        guard let percentage = json["percentage"].int else {
            return nil
        }
        self.percentage = percentage
        self.diceAlreadyRolled = false
        self.previousPercentage = 1000   // just setting it til more than 100 == not set
        super.init(json: json)
    }

    override func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        let triggered = rule.triggersWith(event: event, activeStatuses: activeStatuses)
        let diceRoll = Int(arc4random_uniform(100) + 1)
        return checkIfTriggers(triggered: triggered, diceRoll: diceRoll)
    }

    func checkIfTriggers(triggered: Bool, diceRoll: Int) -> Bool {
        if triggered && !diceAlreadyRolled {
            var diceRolledInFavor = false
            if previousPercentage == 1000 {
                var diceRoll = 100 // this is set to make sure older versions will display the survey after reactivation
                diceRolledInFavor = percentage >= diceRoll
                previousPercentage = diceRoll
            } else {
                diceRolledInFavor = percentage >= previousPercentage
            }
            diceAlreadyRolled = true
            return diceRolledInFavor
        }
        return false
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        let percentage = aDecoder.decodeInteger(forKey: "percentage")
        let diceAlreadyRolled = aDecoder.decodeBool(forKey: "diceAlreadyRolled")
        if aDecoder.containsValue(forKey: "previousPercentage") {
            previousPercentage = aDecoder.decodeInteger(forKey: "previousPercentage")
        } else {
            previousPercentage = 1000
        }
        self.percentage = percentage
        self.diceAlreadyRolled = diceAlreadyRolled
        super.init(coder: aDecoder)
    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.percentage, forKey: "percentage")
        aCoder.encode(self.diceAlreadyRolled, forKey: "diceAlreadyRolled")
        if previousPercentage != 1000 {
            aCoder.encode(self.previousPercentage, forKey: "previousPercentage")
        }
    }

    override func reset() {
        diceAlreadyRolled = false
        super.reset()
    }
}
