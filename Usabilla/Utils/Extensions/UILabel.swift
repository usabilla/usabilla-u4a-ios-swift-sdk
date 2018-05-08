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
     To enable Dynamic Type that allows the system to change the app font size,
     this method is called to apply a custom font and also enable the Dynamic Type.
    
     - parameter font : the custom font to apply to the label
     
     */
    func applyFontWithDynamicTypeEnabled(font: UIFont) {
        self.font = font.getDynamicTypeFont()
    }
}
