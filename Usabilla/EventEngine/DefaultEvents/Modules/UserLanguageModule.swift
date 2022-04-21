//
//  UserLanguageModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct UserLanguageModule: Codable, DefaultEventProtcol {
    var userLanguageEventName = DefaultEventModule.userLanguage.rawValue
    let value: String  // "us-EN"
    let comparison: ComparisonType
    var rule: RuleValue = .and

    init(value: String, comparison: ComparisonType?) {
        self.value = value
        self.comparison = comparison ?? .equal
        userLanguageEventName = DefaultEventModule.userLanguage.rawValue
    }

    func evaluate(_ object: EvaluationObject) -> Bool {
        guard let lang: String = object.get(key: .language) else {return false}
        switch comparison {
        case .lt:
            return lang < self.value
        case .lte:
            return lang <= self.value
        case .equal:
            return lang == self.value
        case .gt:
            return lang > self.value
        case .gte:
            return lang >= self.value
        case .neq:
            return lang != self.value
        }
    }
}
