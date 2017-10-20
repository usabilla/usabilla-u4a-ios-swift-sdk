//
//  UIImageView.swift
//  Usabilla
//
//  Created by Adil Bougamza on 18/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func tintWithColor(color: UIColor) {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
    }
}
