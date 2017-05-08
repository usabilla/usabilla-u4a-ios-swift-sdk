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
    var model: OptionsFieldModel!
    var stackView: UIStackView!


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        rootCellContainerView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: rootCellContainerView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: rootCellContainerView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: rootCellContainerView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rootCellContainerView.rightAnchor).isActive = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func isCurrentlyDisplayedChanged() {
        super.isCurrentlyDisplayedChanged()
    }

    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        guard let item = item as? OptionsFieldModel else {
            return
        }
        model = item
        
        for checkbox in checkBoxes {
            stackView.removeArrangedSubview(checkbox)
            checkbox.removeFromSuperview()
        }

        checkBoxes = []
        
        for option in model.options {
            
            let checkBox = CheckboxWithText()
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.themeConfig = model.themeConfig
            checkBox.delegate = self
            checkBox.checkBox.delegate = self
            checkBox.label.text = option.title
            checkBox.isUserInteractionEnabled = true
            if model.fieldValue.contains(option.value) {
                checkBox.checkBox.on = true
            }
            checkBox.applyCustomisation()
            checkBoxes.append(checkBox)
            stackView.addArrangedSubview(checkBox)
        }
        stackView.layoutIfNeeded()
        stackView.layoutSubviews()
    }

    func didTapCheckBox(_ checkBox: SwiftCheckBox) {
        fatalError("didTapCheckBox has not been implemented")

    }

    func styleCheckBox(_ checkBox: CheckboxWithText) {
        fatalError("styleCheckBox has not been implemented")
    }
}
