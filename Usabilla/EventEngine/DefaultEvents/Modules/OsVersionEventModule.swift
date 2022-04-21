//
//  OsVersionEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct OsVersionEventModule: Codable, DefaultEventProtcol {
    var osVersionName: String = DefaultEventModule.osVersion.rawValue
    let version: String
    let comparison: ComparisonType
    var rule: RuleValue = .and
    let platform: PlatformType

    init( version: String, comparison: ComparisonType?, platform: PlatformType) {
        self.version = version
        self.comparison = comparison ?? .equal
        self.platform = platform
        osVersionName = DefaultEventModule.osVersion.rawValue
    }

    func evaluate (_ object: EvaluationObject) -> Bool {
        guard let targetVersion: String = object.get(key: .osVersion) else {return false}

        switch comparison {
        case .lt:
            return version < targetVersion
        case .lte:
            return version <= targetVersion
        case .equal:
            return version == targetVersion
        case .gt:
            return version > targetVersion
        case .gte:
            return version >= targetVersion
        case .neq:
            return version != targetVersion
        }
    }
}
