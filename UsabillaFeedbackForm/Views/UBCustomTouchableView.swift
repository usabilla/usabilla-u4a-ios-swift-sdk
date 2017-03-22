//
//  UBCustomTouchableView.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBCustomTouchableView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for v in subviews {
            if v.hitTest(convert(point, to: v), with: event) != nil {
                return true
            }
        }
        return false
    }
}
