//
//  EmailComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class EmailComponent: BaseTextFieldComponent<EmailComponentViewModel> {
    override func build() {
        super.build()
        textField.keyboardType = .emailAddress
    }

    func updateBorderColor(email: String?) {
        if let toTest = email {
            let theme = viewModel.theme
            if viewModel.isValid {
                textField.layer.borderColor = theme.hintColor.cgColor
            } else {
                textField.layer.borderColor = theme.errorColor.cgColor
            }
        }
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        updateBorderColor(email: textField.text)
    }
}
