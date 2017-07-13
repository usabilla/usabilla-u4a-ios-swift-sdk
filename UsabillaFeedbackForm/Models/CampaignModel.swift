//
//  CampaignModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignModel: NSObject, NSCoding {

    public enum Status: String {
        case active
        case inactive
        case invalid
    }

    let identifier: String
    var rule: Rule?
    let formId: String
    let targetingId: String
    var numberOfTimesTriggered: Int = 0
    var maximumDisplays: Int
    var status: Status

    var form: FormModel?
    var canBeDisplayed: Bool {
        #if DEBUG
            guard UsabillaFeedbackForm.allowUnlimitedCampaignDisplay == false else {
                return true
            }
        #endif
        return maximumDisplays == 0 || maximumDisplays > numberOfTimesTriggered
    }

    init(id: String, rule: Rule?, formId: String, targetingId: String, maximumDisplays: Int, numberOfTimesTriggered: Int, status: Status) {
        self.identifier = id
        self.rule = rule
        self.formId = formId
        self.targetingId = targetingId
        self.numberOfTimesTriggered = numberOfTimesTriggered
        self.maximumDisplays = maximumDisplays
        self.status = status
    }

    convenience init?(json: JSON) {
        guard let identifier = json["id"].string,
            let formId = json["form_id"].string,
            let targetingId = json["targeting_options_id"].string, let status = Status(rawValue: json["status"].stringValue) else {
                return nil
        }

        self.init(id: identifier, rule: nil, formId: formId, targetingId: targetingId, maximumDisplays: json["maximumDisplays"].int ?? 1, numberOfTimesTriggered: 0, status: status)
    }

    func respondToEvents(event: Event) -> Bool {
        return rule?.respondsToEvent(event: event) ?? false
    }

    func triggers(event: Event) -> Bool {
        return rule?.triggersWith(event: event) ?? false
    }

    // MARK: NSCoding

    // swiftlint:disable force_cast
    public required convenience init?(coder aDecoder: NSCoder) {
        let identifier = aDecoder.decodeObject(forKey: "identifier") as! String
        let rule = aDecoder.decodeObject(forKey: "rule") as? Rule
        let formId = aDecoder.decodeObject(forKey: "formId") as! String
        let targetingId = aDecoder.decodeObject(forKey: "targetingId") as! String
        let numberOfTimesTriggered = aDecoder.decodeInteger(forKey: "numberOfTimesTriggered")
        let maximumDisplays = aDecoder.decodeInteger(forKey: "maximumDisplays")
        let statusStr = aDecoder.decodeObject(forKey: "status") as! String

        let status = Status(rawValue: statusStr)!

        self.init(id: identifier, rule: rule, formId: formId, targetingId: targetingId, maximumDisplays: maximumDisplays, numberOfTimesTriggered: numberOfTimesTriggered, status: status)
    }
    // swiftlint:enable force_cast

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.identifier, forKey: "identifier")
        aCoder.encode(self.rule, forKey: "rule")
        aCoder.encode(self.formId, forKey: "formId")
        aCoder.encode(self.targetingId, forKey: "targetingId")
        aCoder.encode(self.numberOfTimesTriggered, forKey: "numberOfTimesTriggered")
        aCoder.encode(self.maximumDisplays, forKey: "maximumDisplays")
        aCoder.encode(self.status.rawValue, forKey: "status")
    }
}
