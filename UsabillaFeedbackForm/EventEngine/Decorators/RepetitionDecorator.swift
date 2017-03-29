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

    override func customTriggersWith(event: Event) -> Bool {
        if rule.triggersWith(event: event) {
            currentCount = currentCount + 1
        }

        return currentCount >= occurrences
    }

    // MARK: NSCoding
    
    
    public required init?(coder aDecoder: NSCoder) {
        let occurrences = aDecoder.decodeInteger(forKey: "occurrences")
        let currentCount = aDecoder.decodeInteger(forKey: "currentCount")

        self.occurrences = occurrences
        self.currentCount = currentCount
        super.init(coder: aDecoder)

    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.occurrences, forKey: "occurrences")
        aCoder.encode(self.currentCount, forKey: "currentCount")
    }
}
