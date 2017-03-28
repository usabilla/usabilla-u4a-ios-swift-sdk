//
//  CheckboxCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 15/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class CheckboxCellView: BaseCheckboxCellView {


    override func styleCheckBox(_ checkBox: CheckboxWithText) {
        checkBox.checkBox.boxType = .square
        checkBox.checkBox.onAnimationType = .bounce
        checkBox.checkBox.offAnimationType = .bounce
    }

    override func didTapCheckBox(_ checkBox: SwiftCheckBox) {

        //checkBox.setOn(!checkBox.on, animated: true)
        var values: [String] = [ ]

        for (index, checkBox) in checkBoxes.enumerated() {
            let option = super.model.options[index]
            if checkBox.checkBox.on {
                values.append(option.value)
            }
        }
        loggingPrint("values: \(values)")
        super.model.fieldValue = values
    }
}
