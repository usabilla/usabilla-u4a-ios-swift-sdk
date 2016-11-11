//
//  BaseCheckBoxCellView.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 12/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class BaseCheckboxCellView: RootCellView, SwiftCheckBoxDelegate {

    var checkBoxes: [CheckboxWithText] = []
    var model: FieldModelWithOptions!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCheckBoxeslayout() {
        for checkBox in checkBoxes {
            checkBox.height.isActive =  isCurrentlyDisplayed ? true : false
        }
    }

    override func isCurrentlyDisplayedChanged() {
        super.isCurrentlyDisplayedChanged()
        updateCheckBoxeslayout()
    }


    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        model = item as! FieldModelWithOptions
        for checkbox in checkBoxes {
            checkbox.removeFromSuperview()
        }
        checkBoxes = []
        var previousCheckbox: CheckboxWithText?

        for (index, option) in model.options.enumerated() {

            let checkBox = CheckboxWithText()
            checkBox.themeConfig = model.themeConfig
            checkBox.delegate = self
            checkBox.checkBox.delegate = self
            //checkBox.checkBox.delegate = self

            styleCheckBox(checkBox)
            checkBox.label.text = option.title
            checkBox.label.textColor = model.themeConfig.textColor
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.isUserInteractionEnabled = true
            checkBox.applyCustomisation()
            if model.fieldValue.contains(option.value ) {
                checkBox.checkBox.on = true
            }

            self.contentView.addSubview(checkBox)
            checkBoxes.append(checkBox)

            checkBox.height.isActive = true
            NSLayoutConstraint(item: checkBox, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 1, constant: 0).isActive = true

            if index == 0 {
                //First checkbox
                NSLayoutConstraint(item: checkBox, attribute: .top, relatedBy: .equal, toItem: dividerLine, attribute: .bottom, multiplier: 1, constant: 4).isActive = true
            } else {
                let a = NSLayoutConstraint(item: checkBox, attribute: .top, relatedBy: .equal, toItem: previousCheckbox!, attribute: .bottom, multiplier: 1, constant: 8)
                a.priority = 750
                a.isActive = true
            }

            if index == model.options.count - 1 {
                //Last element
                NSLayoutConstraint(item: checkBox, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -12).isActive = true
            }


            previousCheckbox = checkBox
        }
    }

    func didTapCheckBox(_ checkBox: SwiftCheckBox) {
        fatalError("didTapCheckBox has not been implemented")

    }

    func styleCheckBox(_ checkBox: CheckboxWithText) {
        fatalError("styleCheckBox has not been implemented")
    }


//    deinit {
//        print("base checkbox  cell deinit")
//    }
}
