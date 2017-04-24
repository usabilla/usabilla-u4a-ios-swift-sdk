//
//  RadioCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 15/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class RadioCellView: BaseCheckboxCellView {


    override func styleCheckBox(_ checkBox: CheckboxWithText) {
        checkBox.checkBox.boxType = .circle
        checkBox.checkBox.onAnimationType = .bounce
        checkBox.checkBox.offAnimationType = .bounce
    }


    override func didTapCheckBox(_ checkBox: SwiftCheckBox) {

        for checkBox in checkBoxes {
            checkBox.checkBox.setOn(false, animated: true)
        }

        checkBox.setOn(!checkBox.on, animated: true)

        var values: [String] = [ ]

        for (index, checkBox) in checkBoxes.enumerated() where checkBox.checkBox.on {
            let option = super.model.options[index]
                values.append(option.value)
        }
        super.model.fieldValue = values
    }


}
