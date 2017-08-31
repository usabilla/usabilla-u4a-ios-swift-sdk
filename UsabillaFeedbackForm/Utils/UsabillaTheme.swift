//
//  UsabillaTheme.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

public struct UsabillaTheme {

    // MARK: Colors
    public var titleColor: UIColor
    public var textColor: UIColor
    public var accentColor: UIColor
    public var headerColor: UIColor?
    public var textOnAccentColor: UIColor
    public var backgroundColor: UIColor
    public var errorColor: UIColor
    public var hintColor: UIColor {
        return textColor.withAlphaComponent(0.38)
    }

    public var statusBarColor: UIStatusBarStyle

    // MARK: Fonts
    public var customFont: UIFont?
    public var customFontBold: UIFont?
    public var titleFontSize: CGFloat
    public var textFontSize: CGFloat
    public var miniFontSize: CGFloat

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
        return UIFont.systemFont(ofSize: titleFontSize, weight: UIFontWeightSemibold)
    }

    // MARK: Custom images
    public var enabledEmoticons: [UIImage]
    public var disabledEmoticons: [UIImage]?
    public var star: UIImage
    public var starOutline: UIImage

    public init() {
        statusBarColor = .default
        textColor = UIColor(rgba: "#59636B")
        textOnAccentColor = UIColor.white
        accentColor = UIColor(rgba: "#00A5C9")
        titleColor = UIColor(rgba: "#41474C")
        errorColor = UIColor(rgba: "#F4606E")
        backgroundColor = UIColor.white
        enabledEmoticons = UsabillaTheme.createEmoticons()
        disabledEmoticons = nil
        titleFontSize = 17
        textFontSize = 17
        miniFontSize = 15
        headerColor = nil
        //swiftlint:disable force_unwrapping
        star = UsabillaTheme.getImage(withName: "star")!
        starOutline = UsabillaTheme.getImage(withName: "star_outline")!
        //swiftlint:enable force_unwrapping
    }

    fileprivate static func createEmoticons() -> [UIImage] {
        let imagesName = ["hate", "sad", "normal", "happy", "love"]
        return imagesName.map { name in
            //swiftlint:disable:next force_unwrapping
            getImage(withName: name)!
        }
    }

    fileprivate static func getImage(withName name: String) -> UIImage? {
        let bundle = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")
        return UIImage(named: name, in: bundle, compatibleWith: nil)
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

    mutating func updateConfig(json: JSON) {
        // TO DO guard with empty check
        self.titleColor = UIColor(rgbao: json["group1"]["hash"].string) ?? titleColor
        self.accentColor = UIColor(rgbao: json["group2"]["hash"].string) ?? accentColor
        self.textColor = UIColor(rgbao: json["group3"]["hash"].string) ?? textColor
        self.errorColor = UIColor(rgbao: json["group4"]["hash"].string) ?? errorColor
        self.backgroundColor = UIColor(rgbao: json["group5"]["hash"].string) ?? backgroundColor
        self.textOnAccentColor = UIColor(rgbao: json["group6"]["hash"].string) ?? textOnAccentColor
    }
}
