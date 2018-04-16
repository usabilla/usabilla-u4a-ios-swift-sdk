//
//  UILabel.swift
//  Usabilla
//
//  Created by Adil Bougamza on 16/04/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import UIKit

extension UILabel {

    /**
     To enable Dynamic Text that allows the system to change the app font size,
     this method is called to apply a custom font and also enable the Dynamic text.
    
     - parameter font : the custom font to apply to the label
     
     */
    func applyFontWithDynamicTextEnabled(font: UIFont) {
        if #available(iOS 11.0, *) {
            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            self.font = fontMetrics.scaledFont(for: font)
        } else {
            self.font = font
        }
    }
}
