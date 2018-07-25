//
//  UBSlider.swift
//  Usabilla
//
//  Created by Adil Bougamza on 23/07/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class UBSlider: UISlider {

    override var accessibilityValue: String? {
        get {
            let selectedValue = Int(self.value)
            let maxValue = Int(self.maximumValue)
            return "\(selectedValue) \(LocalisationHandler.getLocalisedStringForKey("usa_accessibility_slider_value_over")) \(maxValue)"
        }
        set {
            accessibilityValue = newValue
        }
    }

    override func accessibilityIncrement() {
        self.value += 1
        sendActions(for: .valueChanged)
    }

    override func accessibilityDecrement() {
        self.value -= 1
        sendActions(for: .valueChanged)
    }
}
