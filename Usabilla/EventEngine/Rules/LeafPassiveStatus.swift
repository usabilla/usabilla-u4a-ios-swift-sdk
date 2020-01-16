//
//  LeafPassiveStatus.swift
//  Usabilla
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
        // Legacy Code;  The format of the "Show campaign when the device language is set to XX", has been
        // changed on the frontend.  It now sets the language to eg.  "de"
        // We keep this code for now, to support if it exists for legacy.
        if passiveStatus.value.contains("_") {
            return passiveStatus.value == Locale.current.identifier
        }

        let localeLanguage = String(describing: Locale.preferredLocale()).prefix(2).uppercased()
        return passiveStatus.value.uppercased() == localeLanguage
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
