//
//  UIView.swift
//  Usabilla
//
//  Created by Adil Bougamza on 15/05/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    /// Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach({ self.addSubview($0) })
    }

    #if DEBUG
        /**
         *  Add a border to all UI Components
         */
        func showBorder(width: CGFloat = 1.0, color: UIColor = UIColor.red) {
            layer.borderColor = color.cgColor
            layer.borderWidth = width
        }
    #endif
}
