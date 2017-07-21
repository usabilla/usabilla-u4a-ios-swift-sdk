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
    var childRules: [Rule] { return [rule] }
    var alreadyTriggered: Bool
    var type: RuleType {
        return rule.type
    }
    init(rule: Rule) {
        self.rule = rule
        self.alreadyTriggered = false
    }

    required init?(json: JSON) {
        guard let childRuleJson = json["children"].array?.first,
            let childRule = TargetingFactory.createRule(childRuleJson) else {
                return nil
        }
        self.rule = childRule
        self.alreadyTriggered = false
    }

    func triggersWith(event: Event) -> Bool {
        if !alreadyTriggered {
            alreadyTriggered = customTriggersWith(event: event)
        }
        return alreadyTriggered
    }

    func customTriggersWith(event: Event) -> Bool {
        fatalError("Abstract method not implemented")
    }

    func respondsToEvent(event: Event) -> Bool {
        return childRules.first {
            $0.respondsToEvent(event: event) == true
        } != nil
    }

    func reset() {
        alreadyTriggered = false
        for child in childRules {
            child.reset()
        }
    }

    // MARK: NSCoding
    public required init?(coder aDecoder: NSCoder) {
        guard let rule = aDecoder.decodeObject(forKey: "rule") as? Rule else {
            PLog("❌ impossible to decode Decorator")
            return nil
        }
        let alreadyTriggered = aDecoder.decodeBool(forKey: "alreadyTriggered")

        self.rule = rule
        self.alreadyTriggered = alreadyTriggered
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.rule, forKey: "rule")
        aCoder.encode(self.alreadyTriggered, forKey: "alreadyTriggered")
    }

}
