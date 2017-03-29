//
//  PercentageDecorator.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 21/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

class PercentageDecorator: Decorator {

    var chance: Int

    init(chance: Int, rule: Rule) {
        self.chance = chance
        super.init(rule: rule)
    }

    override func customTriggersWith(event: Event) -> Bool {
        let triggered = rule.triggersWith(event: event)
        let diceRoll = Int(arc4random_uniform(100) + 1)
        return checkIfTriggers(triggered: triggered, diceRoll: diceRoll)
    }
    
    func checkIfTriggers(triggered: Bool, diceRoll: Int) -> Bool {
        return chance >= diceRoll && triggered
    }

    // MARK: NSCoding


    public required init?(coder aDecoder: NSCoder) {
        let chance = aDecoder.decodeInteger(forKey: "chance")
        self.chance = chance
        super.init(coder: aDecoder)

    }

    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.chance, forKey: "chance")
    }
}
