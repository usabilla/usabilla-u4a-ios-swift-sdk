//
//  RadioComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 26/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class RadioComponent: BaseCheckBoxComponent<RadioComponentViewModel> {

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        checkBoxes.forEach {
            $0.checkBox.boxType = .circle
            $0.checkBox.onAnimationType = .bounce
            $0.checkBox.offAnimationType = .bounce
        }
    }

    override func didTapCheckBox(_ checkBox: SwiftCheckBox) {
        var values: [String] = []

        for checkBox in checkBoxes {
            checkBox.checkBox.setOn(false, animated: true)
            checkBox.accessibilityValue = "unselected"
        }

        checkBox.setOn(true, animated: true)

        for (index, checkBox) in checkBoxes.enumerated() where checkBox.checkBox.on == true {
            checkBox.accessibilityValue = "selected"
            let option = viewModel.options[index]
            values.append(option.value)
        }
        viewModel.value = values
        valueChanged()
    }
}
