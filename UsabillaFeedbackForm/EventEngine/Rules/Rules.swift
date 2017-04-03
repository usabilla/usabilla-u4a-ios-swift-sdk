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
    case leaf
    case timer
    case percentage
    case repetition
}
// swiftlint:enable identifier_name

protocol Rule: NSCoding {

    var ruleID: String { get }
    var alreadyTriggered: Bool { get set }
    var type: RuleType { get }
    var childRules: [Rule] { get }

    func triggersWith(event: Event) -> Bool
    func customTriggersWith(event: Event) -> Bool
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

    func triggersWith(event: Event) -> Bool {
        if !alreadyTriggered {
            alreadyTriggered = customTriggersWith(event: event)
        }
        return alreadyTriggered
    }

    func customTriggersWith(event: Event) -> Bool {
        fatalError("Abstract method not implemented")
    }

    // MARK: NSCoding

    public required init?(coder aDecoder: NSCoder) {
        // swiftlint:disable force_cast
        let ruleID = aDecoder.decodeObject(forKey: "ruleID") as! String
        let type = RuleType(rawValue: (aDecoder.decodeObject(forKey: "type") as! String))!
        let childRules = aDecoder.decodeObject(forKey: "childRules") as! [Rule]
        let alreadyTriggered = aDecoder.decodeBool(forKey: "alreadyTriggered")
        // swiftlint:enable force_cast

        self.type = type
        self.ruleID = ruleID
        self.childRules = childRules
        self.alreadyTriggered = alreadyTriggered
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ruleID, forKey: "ruleID")
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.childRules, forKey: "childRules")
        aCoder.encode(self.alreadyTriggered, forKey: "alreadyTriggered")
    }

}
