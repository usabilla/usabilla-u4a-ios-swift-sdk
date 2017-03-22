//
//  NSLayoutConstraint.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    func withId(_ identifier: String?) -> NSLayoutConstraint {
        self.identifier = identifier
        return self
    }
    
    func prioritize(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
    @discardableResult func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }
}
