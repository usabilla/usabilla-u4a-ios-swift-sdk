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
            text = UIColor(red: 89 / 255, green: 99 / 255, blue: 107 / 255, alpha: 1)
            textOnAccent = UIColor.white
            accent = UIColor(red: 0 / 255, green: 165 / 255, blue: 201 / 255, alpha: 1)
            title = UIColor(red: 65 / 255, green: 71 / 255, blue: 76 / 255, alpha: 1)
            error = UIColor(red: 244 / 255, green: 96 / 255, blue: 110 / 255, alpha: 1)
            background = UIColor.white
            cardColor = UIColor.white
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
        //Computed font to use in SDK
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
            //swiftlint:disable force_unwrapping
            star = UIImage.getImageFromSDKBundle(name: "star")!
            starOutline = UIImage.getImageFromSDKBundle(name: "star_outline")!
            //swiftlint:enable force_unwrapping
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
            //swiftlint:disable:next force_unwrapping
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
}
