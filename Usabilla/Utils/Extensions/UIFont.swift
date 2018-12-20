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
