//
//  UsabillaThemeConfigurator.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

open class UsabillaThemeConfigurator {

    open var titleColor: UIColor
    open var textColor: UIColor
    open var accentColor: UIColor
    open var textOnAccentColor: UIColor
    open var backgroundColor: UIColor
    open var errorColor: UIColor
    open var statusBarColor: UIStatusBarStyle
    open var customFont: UIFont?
    open var enabledEmoticons: [UIImage]
    open var disabledEmoticons: [UIImage]?
    open var fullStar: UIImage?
    open var emptyStar: UIImage?
    open var hintColor: UIColor {
        get {
            return textColor.withAlphaComponent(0.38)
        }
    }
    var font: UIFont {
        get {
            if let font = customFont {
                return font
            } else {
                return UIFont.systemFont(ofSize: UIFont.systemFontSize)
            }
        }
    }
    
    open var titleFontSize: CGFloat
    open var textFontSize: CGFloat
    open var miniFontSize: CGFloat

    public init() {
        statusBarColor = .default
        textColor = UIColor(rgba:"#59636B")
        textOnAccentColor = UIColor.white
        accentColor = UIColor(rgba:"#00A5C9")
        titleColor = UIColor(rgba:"#41474C")
        errorColor = UIColor(rgba:"#F4606E")
        backgroundColor = UIColor.white
        enabledEmoticons = UsabillaThemeConfigurator.createEmoticons()
        disabledEmoticons = nil
        fullStar = nil
        emptyStar = nil
        titleFontSize = 18
        textFontSize = 18
        miniFontSize = 15
    }


    fileprivate class func createEmoticons() -> [UIImage] {
        var toReturn: [UIImage] = []
        let bundle = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")
        toReturn.append(UIImage(named: "01", in:  bundle, compatibleWith: nil)!)
        toReturn.append(UIImage(named: "02", in:  bundle, compatibleWith: nil)!)
        toReturn.append(UIImage(named: "03", in:  bundle, compatibleWith: nil)!)
        toReturn.append(UIImage(named: "04", in:  bundle, compatibleWith: nil)!)
        toReturn.append(UIImage(named: "05", in:  bundle, compatibleWith: nil)!)
        return toReturn
    }


}
