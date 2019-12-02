//
//  UBFeatureBillaManagerProtocol.swift
//  Usabilla
//
//  Created by Anders Liebl on 12/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation

enum FeatureLogLevel {
    case interface
    case perfomance
    case subThreads
    case all
    case none // this would probably never be used, when calling shouldLog... but for consistency
}

// The different Types of analytics that we support in FeatureBilla
enum FeatureTypes {
    case telemetrics
}

protocol UBFeatureBillaManagerProtocol {
    func shouldLog(_ type: FeatureTypes, logLevel: FeatureLogLevel) -> Bool
}
