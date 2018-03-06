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

    init(percentage: Int, rule: Rule) {
        self.percentage = percentage
        super.init(rule: rule)
    }

    required init?(json: JSON) {
        guard let percentage = json["percentage"].int else {
            return nil
        }
        self.percentage = percentage
        super.init(json: json)
    }

    override func customTriggersWith(event: Event, activeStatuses: [String : String]) -> Bool {
        let triggered = rule.triggersWith(event: event, activeStatuses: activeStatuses)
        let diceRoll = Int(arc4random_uniform(100) + 1)
        return checkIfTriggers(triggered: triggered, diceRoll: diceRoll)
    }

    func checkIfTriggers(triggered: Bool, diceRoll: Int) -> Bool {
        return percentage >= diceRoll && triggered
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        let percentage = aDecoder.decodeInteger(forKey: "percentage")
        self.percentage = percentage
        super.init(coder: aDecoder)

    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.percentage, forKey: "percentage")
    }
}
