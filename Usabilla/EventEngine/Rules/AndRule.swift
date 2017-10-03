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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(json: JSON) {
        super.init(json: json)
    }

    override func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        for rule in childRules {
            let triggered = rule.triggersWith(event: event, activeStatuses: activeStatuses)
            if !(triggered || rule.alreadyTriggered) {
                return false
            }
        }
        return true
    }
}
