//
//  LeafActiveStatus.swift
//  Usabilla
//
//  Created by Adil Bougamza on 02/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class LeafActiveStatus: ConcreteRule {
    let activeStatus: ActiveStatus

    init(activeStatus: ActiveStatus) {
        self.activeStatus = activeStatus
        super.init(type: .activeStatus, childRules: [], ruleID: "ID-HERE", alreadyTriggered: false)
    }

    required init?(json: JSON) {
        guard let name = json["name"].string, let value = json["value"].string else {
            return nil
        }

        self.activeStatus = ActiveStatus(name: name, value: value)
        super.init(json: json)
    }

    override func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        return activeStatuses[activeStatus.name] == activeStatus.value
    }

    required init?(coder aDecoder: NSCoder) {
        guard let activeStatus = aDecoder.decodeObject(forKey: "activeStatus") as? ActiveStatus else {
            PLog("❌ impossible to decode LeafActiveStatus")
            return nil
        }
        self.activeStatus = activeStatus
        super.init(coder: aDecoder)
    }

    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.activeStatus, forKey: "activeStatus")
        super.encode(with: aCoder)
    }
}
