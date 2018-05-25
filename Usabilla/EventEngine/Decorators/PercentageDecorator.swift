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

    init(percentage: Int, rule: Rule) {
        self.percentage = percentage
        self.diceAlreadyRolled = false
        super.init(rule: rule)
    }

    required init?(json: JSON) {
        guard let percentage = json["percentage"].int else {
            return nil
        }
        self.percentage = percentage
        self.diceAlreadyRolled = false
        super.init(json: json)
    }

    override func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        let triggered = rule.triggersWith(event: event, activeStatuses: activeStatuses)
        let diceRoll = Int(arc4random_uniform(100) + 1)
        return checkIfTriggers(triggered: triggered, diceRoll: diceRoll)
    }

    func checkIfTriggers(triggered: Bool, diceRoll: Int) -> Bool {
        if triggered && !diceAlreadyRolled {
            let diceRolledInFavor = percentage >= diceRoll
            diceAlreadyRolled = true
            return diceRolledInFavor
        }
        return false
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        let percentage = aDecoder.decodeInteger(forKey: "percentage")
        let diceAlreadyRolled = aDecoder.decodeBool(forKey: "diceAlreadyRolled")
        self.percentage = percentage
        self.diceAlreadyRolled = diceAlreadyRolled
        super.init(coder: aDecoder)
    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.percentage, forKey: "percentage")
        aCoder.encode(self.diceAlreadyRolled, forKey: "diceAlreadyRolled")
    }
}
