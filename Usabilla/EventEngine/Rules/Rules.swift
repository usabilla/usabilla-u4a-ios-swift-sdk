//
//  Rule.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 15/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
enum RuleType: String {
    case and
    case or
    case sequence
    case event
    case timer
    case percentage
    case repetition
    case activeStatus
    case passiveStatus
}
// swiftlint:enable identifier_name

protocol Rule: NSCoding {

    var ruleID: String { get }
    var alreadyTriggered: Bool { get set }
    var type: RuleType { get }
    var childRules: [Rule] { get }

    func triggersWith(event: Event, activeStatuses: [String: String]) -> Bool
    func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool
    func respondsToEvent(event: Event) -> Bool
    func reset()
}

class ConcreteRule: NSObject, Rule {

    let ruleID: String
    let type: RuleType
    let childRules: [Rule]

    var alreadyTriggered: Bool

    init(type: RuleType, childRules: [Rule], ruleID: String = UUID().uuidString, alreadyTriggered: Bool = false) {
        self.type = type
        self.ruleID = ruleID
        self.childRules = childRules
        self.alreadyTriggered = alreadyTriggered
    }

    required init?(json: JSON) {
        guard let typeString = json["type"].string,
            let type = RuleType(rawValue: typeString) else {
                return nil
        }

        let childrenJson = json["children"].arrayValue
        self.ruleID = "Fake-rule-id"
        self.type = type
        self.childRules = childrenJson.flatMap { TargetingFactory.createRule($0) }
        self.alreadyTriggered = false
    }

    func triggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        if !alreadyTriggered {
            alreadyTriggered = customTriggersWith(event: event, activeStatuses: activeStatuses)
        }
        return alreadyTriggered
    }

    func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        fatalError("Abstract method not implemented")
    }

    func respondsToEvent(event: Event) -> Bool {
        return childRules.first {
            $0.respondsToEvent(event: event) == true
        } != nil
    }

    func reset() {
        alreadyTriggered = false
        for rule in childRules {
            rule.reset()
        }
    }

    // MARK: NSCoding

    public required init?(coder aDecoder: NSCoder) {
        guard let ruleID = aDecoder.decodeObject(forKey: "ruleID") as? String,
            let ruleType = aDecoder.decodeObject(forKey: "type") as? String,
            let type = RuleType(rawValue: ruleType),
            let childRules = aDecoder.decodeObject(forKey: "childRules") as? [Rule] else {
                PLog("❌ impossible to decode rule")
                return nil
        }

        self.type = type
        self.ruleID = ruleID
        self.childRules = childRules
        self.alreadyTriggered = aDecoder.decodeBool(forKey: "alreadyTriggered")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ruleID, forKey: "ruleID")
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.childRules, forKey: "childRules")
        aCoder.encode(self.alreadyTriggered, forKey: "alreadyTriggered")
    }

}
