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

    override func customTriggersWith(event: Event) -> Bool {
        let triggered = rule.triggersWith(event: event)
        let diceRoll = Int(arc4random_uniform(100) + 1)
        return checkIfTriggers(triggered: triggered, diceRoll: diceRoll)
    }

    func checkIfTriggers(triggered: Bool, diceRoll: Int) -> Bool {
        return percentage >= diceRoll && triggered
    }

    // MARK: NSCoding
    public required init?(coder aDecoder: NSCoder) {
        let percentage = aDecoder.decodeInteger(forKey: "percentage")
        self.percentage = percentage
        super.init(coder: aDecoder)

    }

    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.percentage, forKey: "percentage")
    }
}
