//
//  Locale.swift
//  Usabilla
//
//  Created by Hitesh Jain on 16/01/2020.
//  Copyright © 2020 Usabilla. All rights reserved.
//

import Foundation

extension Locale {
    static func preferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
