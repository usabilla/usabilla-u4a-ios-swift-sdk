//
//  UIFont.swift
//  Usabilla
//
//  Created by Adil Bougamza on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    class func uSystemFont(ofSize: CGFloat, weight: UIFontWeight) -> UIFont {
        if #available(iOS 11, *) {
            // swiftlint:disable force_unwrapping
            switch weight {
            case UIFontWeightSemibold:
                return UIFont(name: "HelveticaNeue-Medium", size: ofSize)!
            default:
                return UIFont(name: "HelveticaNeue", size: ofSize)!
            }
            // swiftlint:enable force_unwrapping
        }

        return UIFont.systemFont(ofSize: ofSize, weight: weight)
    }
}
