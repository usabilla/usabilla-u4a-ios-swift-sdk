//
//  CheckBoxComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 26/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class CheckBoxComponent: BaseCheckBoxComponent<CheckBoxComponentViewModel> {

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        checkBoxes.forEach {
            $0.checkBox.boxType = .square
            $0.checkBox.onAnimationType = .bounce
            $0.checkBox.offAnimationType = .bounce
        }
    }

    override func didTapCheckBox(_ checkBox: SwiftCheckBox) {
        var values: [String] = []

        for (index, checkBoxText) in checkBoxes.enumerated() {
            var accessibilityValue = LocalisationHandler.getLocalisedStringForKey("usa_unselected")
            if checkBoxText.checkBox.on == true {
                let option = viewModel.options[index]
                accessibilityValue = LocalisationHandler.getLocalisedStringForKey("usa_selected")
                values.append(option.value)
            }
            checkBoxText.accessibilityValue = accessibilityValue
        }
        viewModel.value = values
        valueChanged()
    }
}
