//
//  Extension.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 10/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func divideInChunksOfSize(_ chuckSize: Int) -> [String] {
        var arrayToReturn: [String] = []
        let screenshotCharacterCount = self.characters.count
        let numberOfChunks = screenshotCharacterCount / chuckSize
        let lastChunk = screenshotCharacterCount % chuckSize

        if numberOfChunks > 0 {
            for chunk in 0...numberOfChunks - 1 {
                let start = chunk * chuckSize
                let range = NSRange(location: start, length:  chuckSize)
                let section = (self as NSString).substring(with: range)
                arrayToReturn.append(section)
            }
        }
        if lastChunk > 0 {
            let lastRange = NSRange(location: numberOfChunks*chuckSize, length:  lastChunk)
            let section = (self as NSString).substring(with: lastRange)
            arrayToReturn.append(section)
        }

        return arrayToReturn
    }

}


extension UIImage {


    func fixSizeAndOrientation() -> UIImage {

        let currentWidht = self.size.width
        let currentHeight = self.size.height
        var scaleFactor: CGFloat = 1

        if currentWidht > 800 || currentHeight > 1200 {
            if currentHeight > currentWidht {
                scaleFactor = 1200 / currentHeight
            } else {
                scaleFactor = 800 / currentWidht
            }

            let newHeight = Int(currentHeight * scaleFactor)
            let newWidth = Int(currentWidht * scaleFactor)

            UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
            draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        }

        return self
    }


    func renderInColor(_ color: UIColor) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.clip(to: rect, mask: self.cgImage!)
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: img!.cgImage!, scale: 1, orientation: UIImageOrientation.downMirrored)
    }

}

extension UIView {
    class func loadFromNibNamed(_ nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}


extension UIFont {

    func withTraits(_ traits: UIFontDescriptorSymbolicTraits...) -> UIFont? {
        let descriptor = self.fontDescriptor
        if let derp = descriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits)) {
            return UIFont(descriptor: derp, size: 0)
        } else {
            return nil
        }
    }

    func boldItalic() -> UIFont? {
        return withTraits(.traitBold, .traitItalic)
    }

    func italic() -> UIFont? {
        return withTraits(.traitItalic)
    }


    static func registerFontWithFilenameString(_ filenameString: String, bundleIdentifierString: String) {
        if let bundle = Bundle(identifier: bundleIdentifierString) {
            if let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) {
                if let fontData = try? Data(contentsOf: URL(fileURLWithPath: pathForResourceString)) {
                    if let dataProvider = CGDataProvider(data: fontData as CFData) {
                         let fontRef = CGFont(dataProvider)
                            var errorRef: Unmanaged<CFError>? = nil
                            if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
                                NSLog("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")

                        } else {
                            NSLog("UIFont+:  Failed to register font - font could not be loaded.")
                        }
                    } else {
                        NSLog("UIFont+:  Failed to register font - data provider could not be loaded.")
                    }
                } else {
                    NSLog("UIFont+:  Failed to register font - font data could not be loaded.")
                }
            } else {
                NSLog("UIFont+:  Failed to register font - path for resource not found.")
            }
        } else {
            NSLog("UIFont+:  Failed to register font - bundle identifier invalid.")
        }
    }


}

extension UIDevice {

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }

}

//
//  UIColorExtension.swift
//  HEXColor
//
//  Created by R0CKSTAR on 6/13/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//


/**
 MissingHashMarkAsPrefix:   "Invalid RGB string, missing '#' as prefix"
 UnableToScanHexValue:      "Scan hex error"
 MismatchedHexStringLength: "Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8"
 */
enum UIColorInputError: Error {
    case missingHashMarkAsPrefix,
    unableToScanHexValue,
    mismatchedHexStringLength
}

extension UIColor {
    /**
     The shorthand three-digit hexadecimal representation of color.
     #RGB defines to the color #RRGGBB.

     - parameter hex3: Three-digit hexadecimal value.
     - parameter alpha: 0.0 - 1.0. The default is 1.0.
     */
    convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     The shorthand four-digit hexadecimal representation of color with alpha.
     #RGBA defines to the color #RRGGBBAA.

     - parameter hex4: Four-digit hexadecimal value.
     */
    convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.

     - parameter hex6: Six-digit hexadecimal value.
     */
    convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.

     - parameter hex8: Eight-digit hexadecimal value.
     */
    convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, throws error.

     - parameter rgba: String value.
     */
    convenience init(rgba_throws rgba: String) throws {
        guard rgba.hasPrefix("#") else {
            throw UIColorInputError.missingHashMarkAsPrefix
        }

        guard let hexString: String = rgba.substring(from: rgba.characters.index(rgba.startIndex, offsetBy: 1)),
            var hexValue: UInt32 = 0, Scanner(string: hexString).scanHexInt32(&hexValue) else {
                throw UIColorInputError.unableToScanHexValue
        }

        guard hexString.characters.count  == 3
            || hexString.characters.count == 4
            || hexString.characters.count == 6
            || hexString.characters.count == 8 else {
                throw UIColorInputError.mismatchedHexStringLength
        }

        switch hexString.characters.count {
        case 3:
            self.init(hex3: UInt16(hexValue))
        case 4:
            self.init(hex4: UInt16(hexValue))
        case 6:
            self.init(hex6: hexValue)
        default:
            self.init(hex8: hexValue)
        }
    }

    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, fails to default color.

     - parameter rgba: String value.
     */
    convenience init(rgba: String, defaultColor: UIColor = UIColor.clear) {
        guard let color = try? UIColor(rgba_throws: rgba) else {
            self.init(cgColor: defaultColor.cgColor)
            return
        }
        self.init(cgColor: color.cgColor)
    }

    /**
     Hex string of a UIColor instance.

     - parameter rgba: Whether the alpha should be included.
     */
    func hexString(_ includeAlpha: Bool) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }

}
