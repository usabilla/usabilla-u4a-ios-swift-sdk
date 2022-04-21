//
//  PlatformEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct PlatformEventModule: Codable, DefaultEventProtcol {
    var platformName: String = DefaultEventModule.platform.rawValue
    let platform: PlatformType
    let comparison: ComparisonType

    init( platform: String, comparison: ComparisonType?) {
        let aPlatform = PlatformType(rawValue: platform) ?? .all
        self.platform = aPlatform
        self.comparison = comparison ?? .equal
        self.platformName = DefaultEventModule.platform.rawValue
    }

    func evaluate (_ object: EvaluationObject) -> Bool {
        guard let thePlatform: String = object.get(key: .platform),
        let aPlatform = PlatformType(rawValue: thePlatform) else {
            return false
        }
        switch comparison {
        case .gte, .gt, .lt, .lte:
            return false
        case .equal:
            if platform == aPlatform {return true}
            return false
        case .neq:
            if platform != aPlatform {return true}
            return false
        }
    }
    init( platform: PlatformType, comparison: ComparisonType = .equal) {
        self.platform = platform
        self.comparison = comparison
        self.platformName = DefaultEventModule.platform.rawValue
    }
}
