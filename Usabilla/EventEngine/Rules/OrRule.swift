//
//  OrRule.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 16/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

class OrRule: ConcreteRule {

    init(childRules: [Rule], ruleID: String = UUID().uuidString, alreadyTriggered: Bool = false) {
        super.init(type: .or, childRules: childRules, ruleID: ruleID, alreadyTriggered: alreadyTriggered)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(json: JSON) {
        fatalError("init(json:) has not been implemented")
    }

    override func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        for rule in childRules {
            if rule.triggersWith(event: event, activeStatuses: activeStatuses) {
                return true
            }
        }

        return false
    }
}
