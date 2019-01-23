//
//  OccurrencesDecorator.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 22/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

class RepetitionDecorator: Decorator {

    let occurrences: Int
    var currentCount: Int

    init(occurrences: Int, rule: Rule) {
        self.occurrences = occurrences
        currentCount = 0
        super.init(rule: rule)
    }

    required init?(json: JSON) {
        guard let occurences = json["repetition"].int else {
            return nil
        }

        self.occurrences = occurences
        self.currentCount = 0
        super.init(json: json)
    }

    override func customTriggersWith(event: Event, activeStatuses: [String: String]) -> Bool {
        if rule.triggersWith(event: event, activeStatuses: activeStatuses) {
            currentCount += 1
            rule.reset()
        }

        return currentCount >= occurrences
    }

    // MARK: NSCoding

    required init?(coder aDecoder: NSCoder) {
        let occurrences = aDecoder.decodeInteger(forKey: "occurrences")
        let currentCount = aDecoder.decodeInteger(forKey: "currentCount")

        self.occurrences = occurrences
        self.currentCount = currentCount
        super.init(coder: aDecoder)

    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.occurrences, forKey: "occurrences")
        aCoder.encode(self.currentCount, forKey: "currentCount")
    }
}
