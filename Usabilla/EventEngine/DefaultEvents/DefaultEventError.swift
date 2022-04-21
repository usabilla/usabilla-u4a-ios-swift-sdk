//
//  DefaultEventError.swift
//  Usabilla
//
//  Created by Anders Liebl on 13/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct DefaultEventError {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension DefaultEventError: LocalizedError {
    var errorDescription: String? { return message }
//    var failureReason: String? { get }
//    var recoverySuggestion: String? { get }
//    var helpAnchor: String? { get }
}
