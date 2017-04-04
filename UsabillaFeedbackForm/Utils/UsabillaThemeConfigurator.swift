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

    // MARK: Colors
    open var titleColor: UIColor
    open var textColor: UIColor
    open var accentColor: UIColor
    open var headerColor: UIColor?
    open var textOnAccentColor: UIColor
    open var backgroundColor: UIColor
    open var errorColor: UIColor
    open var hintColor: UIColor {
        return textColor.withAlphaComponent(0.38)
    }
    
    open var statusBarColor: UIStatusBarStyle
    
    // MARK: Fonts
    open var customFont: UIFont?
    open var customFontBold: UIFont?
    open var titleFontSize: CGFloat
    open var textFontSize: CGFloat
    open var miniFontSize: CGFloat
    
    
    //Computed font to use in SDK
    var font: UIFont {
        if let font = customFont {
            return font.withSize(textFontSize)
        }
        return UIFont.systemFont(ofSize: textFontSize)
    }
    
    var boldFont: UIFont {
        if let boldFont = customFontBold {
            return boldFont.withSize(titleFontSize)
        }
        if let font = customFont {
            return font.withSize(titleFontSize)
        }
        return UIFont.systemFont(ofSize: titleFontSize)
    }
    
    // MARK: Custom images
    open var enabledEmoticons: [UIImage]
    open var disabledEmoticons: [UIImage]?
    open var fullStar: UIImage?
    open var emptyStar: UIImage?

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
        self.titleColor = UIColor(rgbao: json["group1"]["hash"].string) ?? titleColor
        self.accentColor = UIColor(rgbao: json["group2"]["hash"].string) ?? accentColor
        self.textColor = UIColor(rgbao: json["group3"]["hash"].string) ?? textColor
        self.errorColor = UIColor(rgbao: json["group4"]["hash"].string) ?? errorColor
        self.backgroundColor = UIColor(rgbao: json["group5"]["hash"].string) ?? backgroundColor
        self.textOnAccentColor = UIColor(rgbao: json["group6"]["hash"].string) ?? textOnAccentColor
    }
}
