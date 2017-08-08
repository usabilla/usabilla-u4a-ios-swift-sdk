//
//  LeafPassiveStatus.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 04/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class LeafPassiveStatus: ConcreteRule {

    private struct Archiving {
        static let passiveStatus = "passiveStatus"
    }

    let passiveStatus: PassiveStatus

    init(passiveStatus: PassiveStatus) {
        self.passiveStatus = passiveStatus
        super.init(type: .passiveStatus, childRules: [], ruleID: "ID-HERE", alreadyTriggered: false)
    }

    required init?(json: JSON) {
        guard let name = json["name"].string,
            let nameType = PassiveStatus.PasstiveStatusType(rawValue: name),
            let value = json["value"].string else {
                return nil
        }

        self.passiveStatus = PassiveStatus(name: nameType, value: value)
        super.init(json: json)
    }

    override func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        switch passiveStatus.name {
        case .language:
            return languageMatches()
        }
    }

    func languageMatches() -> Bool {
        if passiveStatus.value.contains("_") {
            return passiveStatus.value == Locale.current.identifier
        }

        return passiveStatus.value.uppercased() == Locale.current.languageCode?.uppercased()
    }

    required init?(coder aDecoder: NSCoder) {
        guard let passiveStatus = aDecoder.decodeObject(forKey: Archiving.passiveStatus) as? PassiveStatus else {
            PLog("❌ impossible to decode LeafPassiveStatus")
            return nil
        }
        self.passiveStatus = passiveStatus
        super.init(coder: aDecoder)
    }

    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.passiveStatus, forKey: Archiving.passiveStatus)
        super.encode(with: aCoder)
    }
}
