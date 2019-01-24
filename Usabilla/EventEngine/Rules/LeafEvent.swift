//
//  LeafEvent.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 24/03/2017.
//  Copyright © 2017 usabilla. All rights reserved.
//

import Foundation

class LeafEvent: ConcreteRule {
    let event: Event

    init(event: Event, ruleID: String = UUID().uuidString, alreadyTriggered: Bool = false) {
        self.event = event
        super.init(type: .event, childRules: [], ruleID: ruleID, alreadyTriggered: alreadyTriggered)
    }

    required init?(json: JSON) {
        guard let name = json["name"].string else {
            return nil
        }

        self.event = Event(name: name)
        super.init(json: json)
    }

    override func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        return self.event == event
    }

    required init?(coder aDecoder: NSCoder) {
        guard let event = aDecoder.decodeObject(forKey: "event") as? Event else {
            PLog("❌ impossible to decode LeafEvent")
            return nil
        }
        self.event = event
        super.init(coder: aDecoder)
    }

    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.event, forKey: "event")
        super.encode(with: aCoder)
    }

    override func respondsToEvent(event: Event) -> Bool {
        return self.event == event
    }
}
