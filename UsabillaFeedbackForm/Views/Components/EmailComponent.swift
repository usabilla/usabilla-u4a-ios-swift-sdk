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
        let theme = viewModel.theme
        textField.layer.borderColor = viewModel.isValid ? theme.hintColor.cgColor : theme.errorColor.cgColor
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        updateBorderColor(email: textField.text)
    }
}
