//
//  UBCustomTouchableView.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class UBCustomTouchableView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subView in subviews {
            if subView.hitTest(convert(point, to: subView), with: event) != nil {
                return true
            }
        }
        return false
    }
}
