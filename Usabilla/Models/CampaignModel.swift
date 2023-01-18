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
        static let resetDurtion = "resetDuration" // Added for reactivation
        static let lastShown = "lastShown" // Added for reactivation
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
    var resetDuration: Int64 = 0
    var lastShown: Date?
    var canBeDisplayed: Bool {
        return maximumDisplays == 0 || maximumDisplays > numberOfTimesTriggered
    }

    init(id: String, targeting: TargetingOptionsModel, formID: String, targetingID: String, maximumDisplays: Int, numberOfTimesTriggered: Int, status: Status, createdAt: Date, position: IntroPageDisplayMode = .bannerBottom, resetDuration: Int64, lastShown: Date) {
        self.identifier = id
        self.targeting = targeting
        self.formID = formID
        self.targetingID = targetingID
        self.numberOfTimesTriggered = numberOfTimesTriggered
        self.maximumDisplays = maximumDisplays
        self.status = status
        self.createdAt = createdAt
        self.position = position
        self.resetDuration = resetDuration
        self.lastShown = lastShown
    }

    convenience init?(json: JSON, targeting: TargetingOptionsModel) {
        guard let identifier = json["id"].string,
            let formID = json["form_id"].string,
            let targetingID = json["targeting_options_id"].string,
            let status = Status(rawValue: json["status"].stringValue),
            let createdAt = json["created_at"].string?.dateFromRFC3339 else {
                return nil
        }
        let reset: Int64 = JSONCampaignParser.calculateReactivationDuration(reactivation: json["reactivation"]) // Returns the reset duration for reactivation
        let position = IntroPageDisplayMode.init(rawValue: json["position"].stringValue ) ?? .bannerBottom

        self.init(id: identifier, targeting: targeting, formID: formID, targetingID: targetingID, maximumDisplays: json["maximumDisplays"].int ?? 1, numberOfTimesTriggered: 0, status: status, createdAt: createdAt, position: position, resetDuration: reset, lastShown: createdAt)
    }

    func respondToEvents(event: Event) -> Bool {
        let result = targeting.rule.respondsToEvent(event: event)
        return result
    }

    func triggers(event: Event, activeStatuses: [String: String]) -> Bool {
        let _ = checkReactivation()
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
        let resetDuration = Int64(aDecoder.decodeInteger(forKey: Archiving.resetDurtion))
        guard let lastShown = aDecoder.decodeObject(forKey: Archiving.lastShown) as? Date else { return nil }

        self.init(id: identifier, targeting: targeting, formID: formID, targetingID: targetingID, maximumDisplays: maximumDisplays, numberOfTimesTriggered: numberOfTimesTriggered, status: status, createdAt: createdAt, position: position, resetDuration: resetDuration,
        lastShown: lastShown)
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
        aCoder.encode(self.resetDuration, forKey: Archiving.resetDurtion)
        aCoder.encode(self.lastShown, forKey: Archiving.lastShown)
    }

    ///  This method will check if a campaing should show
    ///   - Returns Bool - true the campsing is a default event, else fault
    ///
    ///   if it is a standard event, it will always return true, as the standard event always handles showing in its own loop
    ///   If the time since last showing is longer than the one set in the campaign, it will return true if the

    func checkReactivation() -> Bool {
        if let defaultEvent: DefaultEvent = DefaultEventDAO.shared.read(id: targetingID) {
            DLogInfo("Standard Event - \(defaultEvent)")
            return false
        }

        if resetDuration == 0 { return false }
        // numberOfTimesTriggers is > 0 then it has been shown.
        // And we can only show a campaign once. before we can reset
        if numberOfTimesTriggered < maximumDisplays {
            return false  // just to save time
        }

        guard let lastShownLast = lastShown else {
            return false   // just to save time. If there is no lastShown. there is no need to reset.....
        }

        let lastShownDiff = Date().getDateDiff(start: lastShownLast)
            if lastShownDiff >= resetDuration {
                resetCampaignReactivation()
                return true
            }
        return false
    }

    func resetCampaignReactivation() {
        maximumDisplays = 1 // reset back to original value 1
        numberOfTimesTriggered = 0 // reset back to original value 0
        lastShown = createdAt // reset back to original value creation date
        for rule in targeting.rule.childRules where rule is RepetitionDecorator {
            if let aRule = rule as? RepetitionDecorator {
                // If reactivation conditons satisfy then reset the current count to start the counter again
                aRule.currentCount = 0
            }
        }
        targeting.rule.reset()
        return
    }
}
