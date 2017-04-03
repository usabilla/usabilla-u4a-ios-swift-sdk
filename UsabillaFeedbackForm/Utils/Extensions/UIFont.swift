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
        }
        return nil
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

}
