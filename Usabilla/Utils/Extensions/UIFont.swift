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
    enum FontWeight {
        case regular
        case semiBold
    }

    class func uSystemFont(ofSize: CGFloat, weight: FontWeight) -> UIFont {
//        if #available(iOS 11, *) {
//            // swiftlint:disable force_unwrapping
//            switch weight {
//            case .semiBold:
//                return UIFont.sy
//                    UIFont(name: "SanFranciscoText-Semibold", size: ofSize)!
//
//                
//                //systemFont(ofSize: ofSize, weight: UIFontWeightSemibold)//
//            default:
//                return UIFont.systemFont(ofSize: ofSize, weight: UIFontWeightRegular)//UIFont(name: "HelveticaNeue", size: ofSize)!
//            }
//            // swiftlint:enable force_unwrapping
//        }
//
        let uWeight = (weight == .semiBold) ? UIFontWeightSemibold : UIFontWeightRegular
        return UIFont.systemFont(ofSize: ofSize, weight: uWeight)
    }

    func getDynamicTypeFont(forTextStyle style: UIFontTextStyle = .body) -> UIFont {
        if #available(iOS 11, *) {
            let fontMetrics = UIFontMetrics(forTextStyle: style)
            return fontMetrics.scaledFont(for: self)
        }

        return self
    }
}
