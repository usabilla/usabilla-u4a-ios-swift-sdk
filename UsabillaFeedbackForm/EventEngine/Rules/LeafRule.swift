//
//  LeafRule.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 24/03/2017.
//  Copyright © 2017 usabilla. All rights reserved.
//

import Foundation

class LeafRule: ConcreteRule {
    let event: Event

    init(event: Event, ruleID: String = UUID().uuidString, alreadyTriggered: Bool = false) {
        self.event = event
        super.init(type: .leaf, childRules: [], ruleID: ruleID, alreadyTriggered: alreadyTriggered)
    }

    convenience init?(json: JSON) {
        guard let name = json["name"].string else {
            return nil
        }

        self.init(event: Event(name: name))
    }

    override func customTriggersWith(event: Event, activeStatuses: [String : String]) -> Bool {
        return self.event == event
    }

    public required init?(coder aDecoder: NSCoder) {
        guard let event = aDecoder.decodeObject(forKey: "event") as? Event else {
            PLog("❌ impossible to decode leafRule")
            return nil
        }
        self.event = event
        super.init(coder: aDecoder)
    }

    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.event, forKey: "event")
        super.encode(with: aCoder)
    }

    override func respondsToEvent(event: Event) -> Bool {
        return self.event == event
    }
}
