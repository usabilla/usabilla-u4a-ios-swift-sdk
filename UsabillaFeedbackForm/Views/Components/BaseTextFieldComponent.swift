//
//  BaseTextFieldComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseTextFieldComponent<T: EditableStringComponentViewModel>: UBComponent<T>, UITextFieldDelegate {

    var textField: UITextField!
    var line: UIView!

    override func build() {

        textField = UITextField()
        line = UIView()

        textField.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textField)
        addSubview(line)

        textField.delegate = self

        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        line.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        line.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        line.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true

        textField.text = viewModel.value

        //placeholder
        if let placeHolder = viewModel.placeHolder {
            let theme = viewModel.theme
            if let italics = theme.font.withTraits(.traitItalic) {
                textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSForegroundColorAttributeName: theme.hintColor, NSFontAttributeName: italics])
            } else {
                textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSForegroundColorAttributeName: theme.hintColor, NSFontAttributeName: theme.font])
            }
        }

        // customization

        let theme = viewModel.theme
        textField.tintColor = theme.hintColor
        textField.font = theme.font
        textField.textColor = theme.textColor
        textField.backgroundColor = theme.backgroundColor
        line.backgroundColor = theme.hintColor

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.value = textField.text
        valueChanged()
    }

}
