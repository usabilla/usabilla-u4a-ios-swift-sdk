//
//  AppVersionEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct AppVersionEventModule: Codable, DefaultEventProtcol {
    var appVersionName: String = DefaultEventModule.appVersion.rawValue
    let versionValue: String
    let comparison: ComparisonType
    var rule: RuleValue = .and
    let platform: PlatformType

    init( version: String, comparison: ComparisonType?, platform: PlatformType) {
        appVersionName = DefaultEventModule.appVersion.rawValue
        self.versionValue = version
        self.comparison = comparison ?? .equal
        self.platform = platform
    }

    func evaluate (_ object: EvaluationObject) -> Bool {
        guard let targetVersion: String = object.get(key: .appVersion) else {return false}

        switch comparison {
        case .lt:
            return targetVersion < versionValue
        case .lte:
            return targetVersion <= versionValue
        case .equal:
            return targetVersion == versionValue
        case .gt:
            return targetVersion > versionValue
        case .gte:
            return targetVersion >= versionValue
        case .neq:
            return targetVersion != versionValue
        }
    }
}
