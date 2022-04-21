//
//  CustomerVariableModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct CustomerVariableModule: Codable, DefaultEventProtcol {
    var customVariableEventName = DefaultEventModule.customVariable.rawValue
    let key: String
    let value: String
    let comparison: ComparisonType
    var rule: RuleValue = .and

    init(key: String, value: String, comparison: ComparisonType?) {
        self.key = key
        self.value = value
        self.comparison = comparison ?? .equal
        customVariableEventName = DefaultEventModule.customVariable.rawValue
    }

    func evaluate(_ object: EvaluationObject) -> Bool {
        let data = object.getCustomerVariables()
        if data.isEmpty {return false}
        if let value = data[key] {
            switch comparison {
            case .lt:
                return value < self.value
            case .lte:
                return value <= self.value
            case .equal:
                return value == self.value
            case .gt:
                return value > self.value
            case .gte:
                return value >= self.value
            case .neq:
                return value != self.value
            }
        }
        return false
    }
}
