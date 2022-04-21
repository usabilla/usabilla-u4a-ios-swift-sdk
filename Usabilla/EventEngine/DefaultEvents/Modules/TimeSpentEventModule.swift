//
//  TimeSpentEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct TimeSpentEventModule: Codable, DefaultEventProtcol {
    var timeSpentEventName = DefaultEventModule.timeSpent.rawValue
    let value: String
    let timeUnit: TimeUnit
    let comparison: ComparisonType
    var rule: RuleValue = .and

    init( value: String, comparison: ComparisonType?, timeUnit: TimeUnit = .seconds) {
        self.value = value
        self.comparison = comparison ?? .lte
        self.timeUnit = timeUnit
        timeSpentEventName = DefaultEventModule.timeSpent.rawValue
    }
    // swiftlint:disable cyclomatic_complexity
    func evaluate (_ object: EvaluationObject) -> Bool {
        guard let time: String = object.get(key: .timeSpent)
        else {return false}

        var result = false
        switch comparison {
        case .lt:
            if time < value {
                result = true
            }
        case .lte:
            if time <= value {
                result = true
            }
        case .equal:
            if time == value {
                result = true
            }
        case .gt:
            if time > value {
                result = true
            }
        case .gte:
            if time >= value {
                result = true
            }
        case .neq:
            if time != value {
                result = true
            }
        }
        return result
    }
}
