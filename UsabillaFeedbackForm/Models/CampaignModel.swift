//
//  CampaignModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignModel: NSObject, NSCoding {

    private struct Archiving {
        static let createdAt = "createdAt"
        static let formId = "formId"
        static let identifier = "identifier"
        static let maximumDisplays = "maximumDisplays"
        static let numberOfTimesTriggered = "numberOfTimesTriggered"
        static let rule = "rule"
        static let status = "status"
        static let targetingId = "targetingId"
    }

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
    let createdAt: Date
    var form: FormModel?
    var canBeDisplayed: Bool {
        return maximumDisplays == 0 || maximumDisplays > numberOfTimesTriggered
    }

    init(id: String, rule: Rule?, formId: String, targetingId: String, maximumDisplays: Int, numberOfTimesTriggered: Int, status: Status, createdAt: Date) {
        self.identifier = id
        self.rule = rule
        self.formId = formId
        self.targetingId = targetingId
        self.numberOfTimesTriggered = numberOfTimesTriggered
        self.maximumDisplays = maximumDisplays
        self.status = status
        self.createdAt = createdAt
    }

    convenience init?(json: JSON) {
        guard let identifier = json["id"].string,
            let formId = json["form_id"].string,
            let targetingId = json["targeting_options_id"].string, let status = Status(rawValue: json["status"].stringValue),
            let createdAt = json["created_at"].string?.dateFromRFC3339 else {
                return nil
        }

        self.init(id: identifier, rule: nil, formId: formId, targetingId: targetingId, maximumDisplays: json["maximumDisplays"].int ?? 1, numberOfTimesTriggered: 0, status: status, createdAt: createdAt)
    }

    func respondToEvents(event: Event) -> Bool {
        return rule?.respondsToEvent(event: event) ?? false
    }

    func triggers(event: Event, activeStatuses: [String: String]) -> Bool {
        return rule?.triggersWith(event: event, activeStatuses: activeStatuses) ?? false
    }

    // MARK: NSCoding
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let identifier = aDecoder.decodeObject(forKey: Archiving.identifier) as? String,
            let formId = aDecoder.decodeObject(forKey: Archiving.formId) as? String,
            let targetingId = aDecoder.decodeObject(forKey: Archiving.targetingId) as? String,
            let statusStr = aDecoder.decodeObject(forKey: Archiving.status) as? String,
            let createdAt = aDecoder.decodeObject(forKey: Archiving.createdAt) as? Date,
            let status = Status(rawValue: statusStr) else {
                return nil
        }

        let rule = aDecoder.decodeObject(forKey: Archiving.rule) as? Rule
        let maximumDisplays = aDecoder.decodeInteger(forKey: Archiving.maximumDisplays)
        let numberOfTimesTriggered = aDecoder.decodeInteger(forKey: Archiving.numberOfTimesTriggered)

        self.init(id: identifier, rule: rule, formId: formId, targetingId: targetingId, maximumDisplays: maximumDisplays, numberOfTimesTriggered: numberOfTimesTriggered, status: status, createdAt: createdAt)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.identifier, forKey: Archiving.identifier)
        aCoder.encode(self.rule, forKey: Archiving.rule)
        aCoder.encode(self.formId, forKey: Archiving.formId)
        aCoder.encode(self.targetingId, forKey: Archiving.targetingId)
        aCoder.encode(self.numberOfTimesTriggered, forKey: Archiving.numberOfTimesTriggered)
        aCoder.encode(self.maximumDisplays, forKey: Archiving.maximumDisplays)
        aCoder.encode(self.status.rawValue, forKey: Archiving.status)
        aCoder.encode(self.createdAt, forKey: Archiving.createdAt)
    }
}
