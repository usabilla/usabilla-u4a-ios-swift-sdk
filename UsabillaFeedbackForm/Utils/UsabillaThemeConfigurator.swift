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

    public static let sharedInstance = UsabillaThemeConfigurator()


    public var headerColor: UIColor
    public var headerTextColor: UIColor
    public var primaryTextColor: UIColor
    public var accentColor: UIColor
    public var textOnAccentColor: UIColor
    public var backgroundColor: UIColor
    public var errorColor: UIColor
    public var hintColor: UIColor
    public var statusBarColor: UIStatusBarStyle

    public var customFont: UIFont?
    public var enabledEmoticons: [UIImage]
    public var disabledEmoticons: [UIImage]?
    public var fullStar: UIImage?
    public var emptyStar: UIImage?

    private init() {

        //UIFont.registerFontWithFilenameString("MiloOT.ttf", bundleIdentifierString: "com.usabilla.UsabillaFeedbackForm")
        // customFont = UIFont(name: "MiloOT", size: UIFont.systemFontSize())! //UIFont.systemFontOfSize(UIFont.systemFontSize())

        statusBarColor = .Default
        headerColor = UIColor(rgba:"#00A5C9")
        headerTextColor = UIColor.whiteColor()
        primaryTextColor = UIColor(rgba:"#59636B")
        textOnAccentColor = UIColor.whiteColor()
        accentColor = UIColor(rgba:"#00A5C9")
        hintColor = UIColor(rgba:"#9CACBA")
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
