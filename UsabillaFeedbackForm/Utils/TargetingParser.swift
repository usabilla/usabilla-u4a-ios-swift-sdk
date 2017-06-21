//
//  TargetingParser.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 21/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class TargetingParser {
    class func targeting(fromJson json: JSON) -> Rule? {
        let eventExist = json["rule"]["children"].array?.first?["children"].array?.first?["name"].exists() ?? false
        guard eventExist == true else {
            return nil
        }
        let percentageJsonRule = json["rule"]
        let repetitionJsonRule = percentageJsonRule["children"].arrayValue.first!
        let eventJsonRule = repetitionJsonRule["children"].arrayValue.first!

        let percentage = percentageJsonRule["percentage"].int ?? 100
        let repetition = repetitionJsonRule["repetition"].int ?? 1
        let eventName = eventJsonRule["name"].stringValue

        let eventRule = Event(name: eventName)
        let leafRule = LeafRule(event: eventRule)

        let repetitionRule = RepetitionDecorator(occurrences: repetition, rule: leafRule)
        let percentageDecorator = PercentageDecorator(percentage: percentage, rule: repetitionRule)

        return percentageDecorator
    }
}
