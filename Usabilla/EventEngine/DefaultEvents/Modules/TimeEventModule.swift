//
//  TimeEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct TimeEventModule: Codable, DefaultEventProtcol {
    var timeEventName: String = DefaultEventModule.time.rawValue
    private var invalidObject = false

    let time: Date
    let comparison: ComparisonType
    var rule: RuleValue = .and

    init( time: String, comparison: ComparisonType?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let aTime = dateFormatter.date(from: time) {
            self.time = aTime
            self.invalidObject = false
        } else {
            self.time = Date()
            self.invalidObject = true
        }
        self.comparison = comparison ?? .gt
        timeEventName = DefaultEventModule.time.rawValue
    }
    // swiftlint:disable cyclomatic_complexity
    func evaluate (_ object: EvaluationObject) -> Bool {
        if invalidObject {return false}
        guard let currentTime: String = object.get(key: .currentTime),
        let now = currentTime.dateFromRFC3339 else {
            return false
        }
        let result = Calendar.current.compare(time, to: now, toGranularity: .minute)
            switch comparison {
            case .lt:
                if result == .orderedDescending {return true}
            case .lte:
                if result == .orderedDescending || result == .orderedSame {return true}
            case .equal:
                if result == .orderedSame {return true}
            case .gt:
                if result == .orderedAscending {return true}
            case .gte:
                if result == .orderedAscending || result == .orderedSame {return true}
            case .neq:
                if result != .orderedSame {return true}
            }

        return false
    }
}
