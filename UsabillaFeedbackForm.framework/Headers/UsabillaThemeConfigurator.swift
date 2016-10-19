//
//  UsabillaThemeConfigurator.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

public class UsabillaThemeConfigurator {

    public var titleColor: UIColor
    public var textColor: UIColor
    public var accentColor: UIColor
    public var textOnAccentColor: UIColor
    public var backgroundColor: UIColor
    public var errorColor: UIColor
    public var statusBarColor: UIStatusBarStyle
    public var customFont: UIFont?
    public var enabledEmoticons: [UIImage]
    public var disabledEmoticons: [UIImage]?
    public var fullStar: UIImage?
    public var emptyStar: UIImage?
    public var hintColor: UIColor {
        get {
            return textColor.colorWithAlphaComponent(0.38)
        }
    }

    public init() {

        //UIFont.registerFontWithFilenameString("MiloOT.ttf", bundleIdentifierString: "com.usabilla.UsabillaFeedbackForm")
        // customFont = UIFont(name: "MiloOT", size: UIFont.systemFontSize())! //UIFont.systemFontOfSize(UIFont.systemFontSize())

        statusBarColor = .Default
        textColor = UIColor(rgba:"#59636B")
        textOnAccentColor = UIColor.whiteColor()
        accentColor = UIColor(rgba:"#00A5C9")
        titleColor = UIColor(rgba:"#41474C")
        errorColor = UIColor(rgba:"#F4606E")
        backgroundColor = UIColor.whiteColor()
        enabledEmoticons = UsabillaThemeConfigurator.createEmoticons()
        disabledEmoticons = nil
        fullStar = nil
        emptyStar = nil
    }


    private class func createEmoticons() -> [UIImage] {
        var toReturn: [UIImage] = []
        let bundle = NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")
        toReturn.append(UIImage(named: "01", inBundle:  bundle, compatibleWithTraitCollection: nil)!)
        toReturn.append(UIImage(named: "02", inBundle:  bundle, compatibleWithTraitCollection: nil)!)
        toReturn.append(UIImage(named: "03", inBundle:  bundle, compatibleWithTraitCollection: nil)!)
        toReturn.append(UIImage(named: "04", inBundle:  bundle, compatibleWithTraitCollection: nil)!)
        toReturn.append(UIImage(named: "05", inBundle:  bundle, compatibleWithTraitCollection: nil)!)
        return toReturn
    }


}
