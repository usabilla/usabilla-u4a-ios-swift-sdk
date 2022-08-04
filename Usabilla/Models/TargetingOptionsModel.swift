//
//  TargetingOptionsModel.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 17/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class TargetingOptionsModel: NSObject, NSCoding {

    private struct Archiving {
        static let rule = "rule"
        static let targetingID = "targetingID"
        static let lastModifiedDate = "lastModifiedDate"
    }

    var rule: Rule
    let targetingID: String
    let lastModifiedDate: Date?

    init(rule: Rule, targetingID: String, lastModifiedDate: Date?) {
        self.rule = rule
        self.targetingID = targetingID
        self.lastModifiedDate = lastModifiedDate
    }

    convenience init?(json: JSON) {
        guard let targetingID = json["id"].string, let dateString = json["last_modified_at"].string  else {
            return nil
        }
        let modifyDate = dateString.dateFromRFC3339 ?? Date()
        let tempDefaultEvents = json["default_events"]
        if tempDefaultEvents != nil {
            let modules: [JSON] = tempDefaultEvents["modules"].arrayValue
            if modules.count > 0 {
                var defaultEvents = DefaultEvent(json: modules, targetingId: targetingID)
                defaultEvents.targetingId = targetingID
                defaultEvents.creationdate = modifyDate
                DefaultEventDAO.shared.create(defaultEvents)
            }
        }
        guard let rule = TargetingFactory.createRule(json["options"]["rule"]) else {
                return nil
        }
        let lastModifiedDate = json["last_modified_at"].string?.dateFromRFC3339
        self.init(rule: rule, targetingID: targetingID, lastModifiedDate: lastModifiedDate)
    }

    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let targetingID = aDecoder.decodeObject(forKey: Archiving.targetingID) as? String,
            let rule = aDecoder.decodeObject(forKey: Archiving.rule) as? Rule else {
                return nil
        }
        let lastModifiedDate = aDecoder.decodeObject(forKey: Archiving.lastModifiedDate) as? Date
        self.init(rule: rule, targetingID: targetingID, lastModifiedDate: lastModifiedDate)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.targetingID, forKey: Archiving.targetingID)
        aCoder.encode(self.rule, forKey: Archiving.rule)
        aCoder.encode(self.lastModifiedDate, forKey: Archiving.lastModifiedDate)
    }
}
