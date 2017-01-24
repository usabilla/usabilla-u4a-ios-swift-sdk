//
//  UIFont.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

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
    
    func bold() -> UIFont? {
        return withTraits(.traitBold)
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
