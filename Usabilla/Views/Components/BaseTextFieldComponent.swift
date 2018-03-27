//
//  BaseTextFieldComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 23/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

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

        textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControlEvents.editingChanged)

        //placeholder
        if let placeHolder = viewModel.placeHolder {
            let theme = viewModel.theme
            textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSForegroundColorAttributeName: theme.colors.hint, NSFontAttributeName: theme.fonts.font])
        }

        // customization

        let theme = viewModel.theme
        textField.tintColor = theme.colors.hint
        textField.font = theme.fonts.font
        textField.textColor = theme.colors.text
        textField.backgroundColor = theme.colors.background
        line.backgroundColor = theme.colors.hint
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        viewModel.value = textField.text
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        valueChanged()
    }
}
