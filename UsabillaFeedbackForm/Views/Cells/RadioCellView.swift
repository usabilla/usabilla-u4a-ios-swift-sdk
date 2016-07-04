//
//  RadioCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 15/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class RadioCellView: BaseCheckboxCellView {
    
    
    override func styleCheckBox(checkBox: CheckboxWithText) {
        checkBox.checkBox.boxType = .Circle
        checkBox.checkBox.onAnimationType = .Bounce
        checkBox.checkBox.offAnimationType = .Bounce
    }
    
    
    override func didTapCheckBox(checkBox: SwiftCheckBox) {
        
        for checkBox in checkBoxes {
            checkBox.checkBox.setOn(false, animated: true)
        }
        
        checkBox.setOn(!checkBox.on, animated: true)
        
        var values: [String] = [ ]
        
        for (index, checkBox) in checkBoxes.enumerate() {
            let option = super.model.options[index]
            if checkBox.checkBox.on {
                values.append(option.value)
            }
        }
        super.model.fieldValue = values
    }
}
