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
        var safeTopAnchor: NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.topAnchor
            }
            return self.topAnchor
        }

        var safeLeftAnchor: NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.leftAnchor
            }
            return self.leftAnchor
        }

        var safeRightAnchor: NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.rightAnchor
            }
            return self.rightAnchor
        }

        var safeBottomAnchor: NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.bottomAnchor
            }
            return self.bottomAnchor
        }

    class var safeAreaEdgeInsets: UIEdgeInsets {
        guard DeviceInfo.hasTopNotch else {
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

//    #if DEBUG
        /**
         *  Add a border to all UI Components
         */
        func showBorder(width: CGFloat = 1.0, color: UIColor = UIColor.red) {
            layer.borderColor = color.cgColor
            layer.borderWidth = width
        }
//    #endif
}
