//
//  Decorator.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 20/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

class Decorator: NSObject, Rule {

    var rule: Rule
    var ruleID: String { return rule.ruleID }
    var childRules: [Rule] { return rule.childRules }
    var alreadyTriggered: Bool
    var type: RuleType {
            return rule.type
    }
    init(rule: Rule) {
        self.rule = rule
        self.alreadyTriggered = false
    }

    func triggersWith(event: Event) -> Bool {
        return customTriggersWith(event: event)
    }


    func customTriggersWith(event: Event) -> Bool {
        fatalError("Abstract method not implemented")
    }


    // MARK: NSCoding


    public required init?(coder aDecoder: NSCoder) {
        let rule = aDecoder.decodeObject(forKey: "rule") as? Rule
        let alreadyTriggered = aDecoder.decodeBool(forKey: "alreadyTriggered")

        self.rule = rule!
        self.alreadyTriggered = alreadyTriggered
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.rule, forKey: "rule")
        aCoder.encode(self.alreadyTriggered, forKey: "alreadyTriggered")
    }



}
