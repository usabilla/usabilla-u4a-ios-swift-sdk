//
//  CampaignModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignModel: NSObject, NSCoding {

    private struct Archiving {
        static let createdAt = "createdAt"
        static let formID = "formID"
        static let identifier = "identifier"
        static let maximumDisplays = "maximumDisplays"
        static let numberOfTimesTriggered = "numberOfTimesTriggered"
        static let targeting = "targeting"
        static let status = "status"
        static let targetingID = "targetingID"
        static let position = "position"
    }

    enum Status: String {
        case active
        case inactive
        case invalid
    }

    let identifier: String
    var targeting: TargetingOptionsModel
    let formID: String
    let targetingID: String
    var numberOfTimesTriggered: Int = 0
    var maximumDisplays: Int
    var status: Status
    let createdAt: Date
    var form: FormModel?
    var position: IntroPageDisplayMode
    var canBeDisplayed: Bool {
        return maximumDisplays == 0 || maximumDisplays > numberOfTimesTriggered
    }

    init(id: String, targeting: TargetingOptionsModel, formID: String, targetingID: String, maximumDisplays: Int, numberOfTimesTriggered: Int, status: Status, createdAt: Date, position: IntroPageDisplayMode = .bannerBottom ) {
        self.identifier = id
        self.targeting = targeting
        self.formID = formID
        self.targetingID = targetingID
        self.numberOfTimesTriggered = numberOfTimesTriggered
        self.maximumDisplays = maximumDisplays
        self.status = status
        self.createdAt = createdAt
        self.position = position
    }

    convenience init?(json: JSON, targeting: TargetingOptionsModel) {
        guard let identifier = json["id"].string,
            let formID = json["form_id"].string,
            let targetingID = json["targeting_options_id"].string,
            let status = Status(rawValue: json["status"].stringValue),
            let createdAt = json["created_at"].string?.dateFromRFC3339 else {
                return nil
        }

        let position = IntroPageDisplayMode.init(rawValue: json["position"].stringValue ) ?? .bannerBottom

        self.init(id: identifier, targeting: targeting, formID: formID, targetingID: targetingID, maximumDisplays: json["maximumDisplays"].int ?? 1, numberOfTimesTriggered: 0, status: status, createdAt: createdAt, position: position)
    }

    func respondToEvents(event: Event) -> Bool {
        return targeting.rule.respondsToEvent(event: event)
    }

    func triggers(event: Event, activeStatuses: [String: String]) -> Bool {
        return targeting.rule.triggersWith(event: event, activeStatuses: activeStatuses)
    }

    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let identifier = aDecoder.decodeObject(forKey: Archiving.identifier) as? String,
            let formID = aDecoder.decodeObject(forKey: Archiving.formID) as? String,
            let targetingID = aDecoder.decodeObject(forKey: Archiving.targetingID) as? String,
            let statusStr = aDecoder.decodeObject(forKey: Archiving.status) as? String,
            let createdAt = aDecoder.decodeObject(forKey: Archiving.createdAt) as? Date,
            let targeting = aDecoder.decodeObject(forKey: Archiving.targeting) as? TargetingOptionsModel,
            let status = Status(rawValue: statusStr) else {
                return nil
        }
        let aPosition = aDecoder.decodeObject(forKey: Archiving.position) as? String
        var position: IntroPageDisplayMode = .bannerBottom
        if let pos = aPosition {
            position = IntroPageDisplayMode(rawValue: pos) ?? .bannerBottom
        }
        let maximumDisplays = aDecoder.decodeInteger(forKey: Archiving.maximumDisplays)
        let numberOfTimesTriggered = aDecoder.decodeInteger(forKey: Archiving.numberOfTimesTriggered)

        self.init(id: identifier, targeting: targeting, formID: formID, targetingID: targetingID, maximumDisplays: maximumDisplays, numberOfTimesTriggered: numberOfTimesTriggered, status: status, createdAt: createdAt, position: position)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.identifier, forKey: Archiving.identifier)
        aCoder.encode(self.targeting, forKey: Archiving.targeting)
        aCoder.encode(self.formID, forKey: Archiving.formID)
        aCoder.encode(self.targetingID, forKey: Archiving.targetingID)
        aCoder.encode(self.numberOfTimesTriggered, forKey: Archiving.numberOfTimesTriggered)
        aCoder.encode(self.maximumDisplays, forKey: Archiving.maximumDisplays)
        aCoder.encode(self.status.rawValue, forKey: Archiving.status)
        aCoder.encode(self.createdAt, forKey: Archiving.createdAt)
        aCoder.encode(self.position.rawValue, forKey: Archiving.position)
    }
}
