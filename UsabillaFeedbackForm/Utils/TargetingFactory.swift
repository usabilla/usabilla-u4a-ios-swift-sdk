//
//  TargetingFactory.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 21/07/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class TargetingFactory {

    enum TargetingType: String {
        case percentage
        case repetition
        case event
    }

    class func createRule(_ json: JSON) -> Rule? {
        let type = json["type"].stringValue

        guard let targetingType = TargetingType(rawValue: type) else {
            return nil
        }

        switch targetingType {
        case .percentage:
            return PercentageDecorator(json: json)
        case .repetition:
            return RepetitionDecorator(json: json)
        case .event:
            return LeafRule(json: json)
        }
    }
}