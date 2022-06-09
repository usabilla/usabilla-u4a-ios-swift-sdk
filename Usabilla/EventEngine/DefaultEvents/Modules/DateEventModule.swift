//
//  DateEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct DateEventModule: Codable, DefaultEventProtcol {
    var dateEventName: String = DefaultEventModule.date.rawValue
    private var invalidObject = false

    let date: Date
    let comparison: ComparisonType
    var rule: RuleValue = .and

    init( date: String, comparison: ComparisonType?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let aDate = dateFormatter.date(from: date) {
            self.date = aDate
            self.invalidObject = false
        } else {
            self.date = Date()
            self.invalidObject = true
        }
        self.comparison = comparison ?? .equal
        dateEventName = DefaultEventModule.date.rawValue
    }
    // swiftlint:disable cyclomatic_complexity
    func evaluate (_ object: EvaluationObject) -> Bool {
        if invalidObject {return false}
        guard let currentTime: String = object.get(key: .currentTime),
        let now = currentTime.dateFromRFC3339 else {
            return false
        }
        let result = Calendar.current.compare(date, to: now, toGranularity: .day)
            switch comparison {
            case .lt:
                if result == .orderedAscending {return true}
            case .lte:
                if result == .orderedAscending || result == .orderedSame {return true}
            case .equal:
                if result == .orderedSame {return true}
            case .gt:
                if result == .orderedDescending {return true}
            case .gte:
                if result == .orderedDescending || result == .orderedSame {return true}
            case .neq:
                if result != .orderedSame {return true}
            }
        return false
    }
}
