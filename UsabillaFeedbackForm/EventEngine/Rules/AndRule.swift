//
//  AndRule.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 16/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation


class AndRule: ConcreteRule {


    init(childRules: [Rule], ruleID: String = UUID().uuidString, alreadyTriggered: Bool = false) {
        super.init(type: .and, childRules: childRules, ruleID: ruleID, alreadyTriggered: alreadyTriggered)
    }

    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override func customTriggersWith(event: Event) -> Bool {

        var allSatisfied = true

        for rule in childRules {
            let triggered = rule.triggersWith(event: event)
            if !(triggered || rule.alreadyTriggered) {
                allSatisfied = false
            }
        }
        return allSatisfied
    }
}
