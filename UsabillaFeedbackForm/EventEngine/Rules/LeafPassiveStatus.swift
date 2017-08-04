//
//  LeafPassiveStatus.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 04/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class PassiveStatus: NSObject, NSCoding {

    enum PasstiveStatusType: String {
        case language
        case iosVersion
    }

    let name: PasstiveStatusType
    let value: String

    init(name: PasstiveStatusType, value: String) {
        self.name = name
        self.value = value
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let nameType = PasstiveStatusType(rawValue: name),
            let value = aDecoder.decodeObject(forKey: "value") as? String else {
                PLog("❌ impossible to decode ActiveStatus")
                return nil
        }

        self.name = nameType
        self.value = value
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name.rawValue, forKey: "name")
        aCoder.encode(self.value, forKey: "value")
    }
}

class LeafPassiveStatus: ConcreteRule {
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
        default:
            return languageMatches()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        guard let passiveStatus = aDecoder.decodeObject(forKey: "passiveStatus") as? PassiveStatus else {
            PLog("❌ impossible to decode LeafActiveStatus")
            return nil
        }
        self.passiveStatus = passiveStatus
        super.init(coder: aDecoder)
    }

    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.passiveStatus, forKey: "passiveStatus")
        super.encode(with: aCoder)
    }
}

extension LeafPassiveStatus {
    func languageMatches() -> Bool {
        let identifier = Locale.current.identifier
        return passiveStatus.value == identifier
    }
}
