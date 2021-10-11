//
//  UsabillaTheme.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

public struct UsabillaTheme: Equatable {

    public var colors: Colors
    public var fonts: Fonts
    public var images: Images
    public var statusBarStyle: UIStatusBarStyle?

    public static func == (lhs: UsabillaTheme, rhs: UsabillaTheme) -> Bool {
        return
            lhs.colors == rhs.colors &&
            lhs.fonts == rhs.fonts &&
            lhs.images == rhs.images &&
            lhs.statusBarStyle == rhs.statusBarStyle
    }

    // MARK: Colors
    public struct Colors: Equatable {
        public var header: UIColor?
        var title: UIColor
        var text: UIColor
        var accent: UIColor
        var textOnAccent: UIColor
        var background: UIColor
        var cardColor: UIColor
        var error: UIColor
        var hint: UIColor {
            return text.withAlphaComponent(0.38)
        }

        public static func == (lhs: Colors, rhs: Colors) -> Bool {
            return
                lhs.header == rhs.header &&
                lhs.title == rhs.title &&
                lhs.text == rhs.text &&
                lhs.accent == rhs.accent &&
                lhs.textOnAccent == rhs.textOnAccent &&
                lhs.background == rhs.background &&
                lhs.cardColor == rhs.cardColor &&
                lhs.error == rhs.error &&
                lhs.hint == rhs.hint
        }

        init() {
            text = UBStyle.LightTheme.text
            textOnAccent = UBStyle.LightTheme.textOnAccent
            accent = UBStyle.LightTheme.accent
            title = UBStyle.LightTheme.title
            error = UBStyle.LightTheme.error
            background = UBStyle.LightTheme.background
            cardColor = UBStyle.LightTheme.cardColor
            header = nil
        }

        mutating func update(withJSON json: JSON) {
            title = UIColor(rgbao: json["group1"]["hash"].string) ?? title
            accent = UIColor(rgbao: json["group2"]["hash"].string) ?? accent
            text = UIColor(rgbao: json["group3"]["hash"].string) ?? text
            error = UIColor(rgbao: json["group4"]["hash"].string) ?? error
            background = UIColor(rgbao: json["group5"]["hash"].string) ?? background
            textOnAccent = UIColor(rgbao: json["group6"]["hash"].string) ?? textOnAccent
            cardColor = UIColor(rgbao: json["group7"]["hash"].string) ?? background
        }

        mutating func updateDarkModeColors(lightColors: JSON, darkColors: JSON) {
            title = (UIColor(rgbao: lightColors["group1"]["hash"].string) ?? title) | (UIColor(rgbao: darkColors["group1"]["hash"].string) ?? UBStyle.DarkTheme.title)
            accent = (UIColor(rgbao: lightColors["group2"]["hash"].string) ?? accent) | (UIColor(rgbao: darkColors["group2"]["hash"].string) ?? UBStyle.DarkTheme.accent)
            text = (UIColor(rgbao: lightColors["group3"]["hash"].string) ?? text) | (UIColor(rgbao: darkColors["group3"]["hash"].string) ?? UBStyle.DarkTheme.text)
            error = (UIColor(rgbao: lightColors["group4"]["hash"].string) ?? error) | (UIColor(rgbao: darkColors["group4"]["hash"].string) ?? UBStyle.DarkTheme.error)
            background = (UIColor(rgbao: lightColors["group5"]["hash"].string) ?? background) | (UIColor(rgbao: darkColors["group5"]["hash"].string) ?? UBStyle.DarkTheme.background)
            textOnAccent = (UIColor(rgbao: lightColors["group6"]["hash"].string) ?? textOnAccent) | (UIColor(rgbao: darkColors["group6"]["hash"].string) ?? UBStyle.DarkTheme.textOnAccent)
            cardColor = (UIColor(rgbao: lightColors["group7"]["hash"].string) ?? background) | (UIColor(rgbao: darkColors["group7"]["hash"].string) ?? background)
        }
    }

    // MARK: Fonts
    public struct Fonts: Equatable {
        public var regular: UIFont?
        public var bold: UIFont?
        public var titleSize: CGFloat
        public var textSize: CGFloat
        public var miniSize: CGFloat

        public static func == (lhs: Fonts, rhs: Fonts) -> Bool {
            return lhs.regular == rhs.regular &&
            lhs.bold == rhs.bold &&
            lhs.titleSize == rhs.titleSize &&
            lhs.textSize == rhs.textSize &&
            lhs.miniSize == rhs.miniSize
        }
        // Computed font to use in SDK
        var font: UIFont {
            if let font = regular {
                return font.withSize(textSize)
            }

            return UIFont.uSystemFont(ofSize: textSize, weight: .regular)
        }

        var boldFont: UIFont {
            if let boldFont = bold {
                return boldFont.withSize(titleSize)
            }
            if let font = regular {
                return font.withSize(titleSize)
            }

            return UIFont.uSystemFont(ofSize: textSize, weight: .semiBold)
        }

        init() {
            titleSize = 17
            textSize = 17
            miniSize = 15
        }
    }

    // MARK: Custom images
    public struct Images: Equatable {
        public var enabledEmoticons: [UIImage]
        public var disabledEmoticons: [UIImage]?
        public var star: UIImage
        public var starOutline: UIImage

        init() {
            enabledEmoticons = UsabillaTheme.createEmoticons()
            disabledEmoticons = nil
            // swiftlint:disable force_unwrapping
            star = UIImage.getImageFromSDKBundle(name: "star")!
            starOutline = UIImage.getImageFromSDKBundle(name: "star_outline")!
            // swiftlint:enable force_unwrapping
        }

        public static func == (lhs: Images, rhs: Images) -> Bool {
            return lhs.enabledEmoticons == rhs.enabledEmoticons &&
            lhs.disabledEmoticons == rhs.disabledEmoticons &&
            lhs.star == rhs.star &&
            lhs.starOutline == rhs.starOutline
        }

    }

    public init() {
        colors = Colors()
        images = Images()
        fonts = Fonts()
    }

    fileprivate static func createEmoticons() -> [UIImage] {
        let imagesName = ["hate", "sad", "normal", "happy", "love"]
        return imagesName.map { name in
            // swiftlint:disable:next force_unwrapping
            UIImage.getImageFromSDKBundle(name: name)!
        }
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

    mutating func updateColors(json: JSON) {
        self.colors.update(withJSON: json)
    }

    mutating func updateDarkColors(lightModeColors: JSON, darkModeColors: JSON) {
        self.colors.updateDarkModeColors(lightColors: lightModeColors, darkColors: darkModeColors)
    }
}


// MARK: - Customise features

public struct ThemeBanner {
    var image: UIImage?
    var clickThrough: Bool = false
}
