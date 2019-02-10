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
    var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3.0
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func build() {

        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        addSubview(borderView)
        borderView.addSubview(textField)

        borderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        borderView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        borderView.topAnchor.constraint(equalTo: topAnchor, constant: -8).isActive = true
        borderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        textField.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -10).isActive = true
        textField.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 7).isActive = true
        textField.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -7).isActive = true

        textField.delegate = self

        textField.text = viewModel.value

        textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControlEvents.editingChanged)

        //placeholder
        if let placeHolder = viewModel.placeHolder {
            let theme = viewModel.theme
            textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor: theme.colors.hint, NSAttributedStringKey.font: theme.fonts.font])
        }

        // customization

        let theme = viewModel.theme
        textField.tintColor = theme.colors.hint
        textField.font = theme.fonts.font.getDynamicTypeFont()
        textField.textColor = theme.colors.text
        textField.backgroundColor = .clear
        borderView.layer.borderColor = theme.colors.hint.cgColor
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        viewModel.value = textField.text
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        valueChanged()
    }
}
