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

    class var safeAreaEdgeInsets: UIEdgeInsets {
        guard DeviceInfo.isIphoneX() else {
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown, .faceUp, .faceDown, .unknown:
                return UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
            case .landscapeLeft, .landscapeRight:
                return UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
            }
        }
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown, .faceUp, .faceDown, .unknown:
            return UIEdgeInsets(top: 88.0, left: 0, bottom: 34.0, right: 0)
        case .landscapeLeft, .landscapeRight:
            return UIEdgeInsets(top: 32.0, left: 44.0, bottom: 21.0, right: 44.0)
        }
    }

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
