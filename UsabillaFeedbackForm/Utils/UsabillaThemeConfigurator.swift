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
    open var headerColor: UIColor?
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
        return textColor.withAlphaComponent(0.38)
    }
    var font: UIFont {
        if let font = customFont {
            return font
        }
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    open var titleFontSize: CGFloat
    open var textFontSize: CGFloat
    open var miniFontSize: CGFloat
    open var setTitlesInBold: Bool

    public init() {
        statusBarColor = .default
        textColor = UIColor(rgba: "#59636B")
        textOnAccentColor = UIColor.white
        accentColor = UIColor(rgba: "#00A5C9")
        titleColor = UIColor(rgba: "#41474C")
        errorColor = UIColor(rgba: "#F4606E")
        backgroundColor = UIColor.white
        enabledEmoticons = UsabillaThemeConfigurator.createEmoticons()
        disabledEmoticons = nil
        fullStar = nil
        emptyStar = nil
        titleFontSize = 17
        textFontSize = 17
        miniFontSize = 15
        setTitlesInBold = true
        headerColor = nil
    }

    fileprivate class func createEmoticons() -> [UIImage] {
        var toReturn: [UIImage] = []
        let bundle = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")
        toReturn.append(UIImage(named: "01", in: bundle, compatibleWith: nil)!)
        toReturn.append(UIImage(named: "02", in: bundle, compatibleWith: nil)!)
        toReturn.append(UIImage(named: "03", in: bundle, compatibleWith: nil)!)
        toReturn.append(UIImage(named: "04", in: bundle, compatibleWith: nil)!)
        toReturn.append(UIImage(named: "05", in: bundle, compatibleWith: nil)!)
        return toReturn
    }

    /**
     Get the correct array of emoticons if mood control contains only 2 or 3 moods
     
     - parameter size: the size of the mood array
     - parameter emoticons: array of emoticons to create the new array from
     - returns : [UIImage]? array of emoticon images adjusted to the size wanted
    */
    func emoticons(size: Int, emoticons: [UIImage]?) -> [UIImage]? {
        guard let array = emoticons, array.count == 5 else {
            return nil
        }

        switch size {
        case 2:
            return [array[0], array[4]]
        case 3:
            return [array[0], array[2], array[4]]
        default:
            return array
        }
    }

    func updateConfig(json: JSON) {
        // TO DO guard with empty check
        if let titleColorHex = json["group1"]["hash"].string {
            titleColor = UIColor(rgba: titleColorHex)
        }
        if let accentColorHex = json["group2"]["hash"].string {
            accentColor = UIColor(rgba: accentColorHex)
        }
        if let textColorHex = json["group3"]["hash"].string {
            textColor = UIColor(rgba: textColorHex)
        }
        if let errorColorHex = json["group4"]["hash"].string {
            errorColor = UIColor(rgba: errorColorHex)
        }
        if let backgroundColorHex = json["group5"]["hash"].string {
            backgroundColor = UIColor(rgba: backgroundColorHex)
        }
        if let textOnAccentHex = json["group6"]["hash"].string {
            textOnAccentColor = UIColor(rgba: textOnAccentHex)
        }
    }
}
