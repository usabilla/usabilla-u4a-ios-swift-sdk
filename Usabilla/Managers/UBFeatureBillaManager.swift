//
//  FeatureBillaService.swift
//  Usabilla
//
//  Created by Anders Liebl on 12/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
class UBFeatureBillaManager: UBFeatureBillaManagerProtocol {
    func shouldLog(_ type: FeatureTypes, logLevel: FeatureLogLevel) -> Bool {
        return true
    }
}
