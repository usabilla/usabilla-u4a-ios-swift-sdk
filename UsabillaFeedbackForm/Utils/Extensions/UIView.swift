//
//  UIView.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 15/05/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

#if DEBUG
    extension UIView {
        /**
         *  Add a border to all UI Components
         */
        func showBorder(width: CGFloat = 1.0, color: UIColor = UIColor.red) {
            layer.borderColor = color.cgColor
            layer.borderWidth = width
        }
    }
#endif
