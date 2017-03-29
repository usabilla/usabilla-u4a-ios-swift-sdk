//
//  CampaignModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class Campaign: NSObject, NSCoding {
    
    let rule: Rule
    let formId: String
    let scheduling: Scheduling
    var numberOfTimesTriggered: Int
    let displayMoreThanOnce: Bool
    var version: Int
    
    init(rule: Rule, formId: String, scheduling: Scheduling, displayMoreThanOnce: Bool, numberOfTimesTriggered: Int = 0, version: Int) {
        self.rule = rule
        self.formId = formId
        self.scheduling = scheduling
        self.numberOfTimesTriggered = numberOfTimesTriggered
        self.displayMoreThanOnce = displayMoreThanOnce
        self.version = version
    }
    
    func triggers(event: Event) -> Bool {
        if scheduling.isWithinScheduling() {
            return rule.triggersWith(event: event)
        }
        return false
    }
    
    
    // MARK: NSCoding
    
    // swiftlint:disable force_cast
    public required convenience init?(coder aDecoder: NSCoder) {
        let rule = aDecoder.decodeObject(forKey: "rule") as! Rule
        let formId = aDecoder.decodeObject(forKey:"formId") as! String
        let scheduling = aDecoder.decodeObject(forKey:"scheduling") as! Scheduling
        let numberOfTimesTriggered = aDecoder.decodeInteger(forKey: "numberOfTimesTriggered")
        let displayMoreThanOnce = aDecoder.decodeBool(forKey: "displayMoreThanOnce")
        let version = aDecoder.decodeInteger(forKey: "version")
        
        self.init(rule: rule, formId: formId, scheduling: scheduling, displayMoreThanOnce: displayMoreThanOnce, numberOfTimesTriggered: numberOfTimesTriggered, version: version)
    }
    // swiftlint:enable force_cast
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.rule, forKey: "rule")
        aCoder.encode(self.formId, forKey: "formId")
        aCoder.encode(self.scheduling, forKey: "scheduling")
        aCoder.encode(self.numberOfTimesTriggered, forKey: "numberOfTimesTriggered")
        aCoder.encode(self.displayMoreThanOnce, forKey: "displayMoreThanOnce")
        aCoder.encode(self.version, forKey: "version")
        
    }
    
}
