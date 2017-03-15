//
//  CheckBoxComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 26/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

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

        for (index, checkBox) in checkBoxes.enumerated() {
            let option = viewModel.options[index]
            if checkBox.checkBox.on {
                values.append(option.value)
            }
        }
        viewModel.value = values
    }

}
