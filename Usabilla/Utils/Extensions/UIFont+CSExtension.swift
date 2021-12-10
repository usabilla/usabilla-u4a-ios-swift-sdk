//
//  UIFont+CSExtension.swift
//  UsabillaCS
//
//  Created by Anders Liebl on 23/10/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    /**
     This method is used in the setTheme function in UsabillaCSInternal
     
     It grabs all fonts (.ttf only) in the /Data/Raw directiory and installs them in the application
     The /Data/Raw directiory is a **Unity** populated Diretory.It copies all assets from /Assets/StreamingAssets during the build phase
     
     If the font has already been installed a notification message will be printed to the log
     */
    class func loadAllFonts() {
        guard let bundlename = Bundle.main.bundleIdentifier, let frameworkBundle = Bundle(identifier: bundlename) else { return }
        let paths = frameworkBundle.paths(forResourcesOfType: "ttf", inDirectory: "/Data/Raw")
        paths.forEach {
            registerFontWithFilenameString($0)}
    }
        
    fileprivate class func registerFontWithFilenameString(_ fontPath: String) {
        guard let bundlename = Bundle.main.bundleIdentifier, let frameworkBundle = Bundle(identifier: bundlename) else { return }
                if let fontData = NSData(contentsOfFile: fontPath) {
            guard let dataProvider = CGDataProvider(data: fontData) else { return}
            guard let fontRef = CGFont(dataProvider) else { return}
            var errorRef: Unmanaged<CFError>? = nil
            if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
                print("error \(errorRef)")
                print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
            }
        }
    }

}
