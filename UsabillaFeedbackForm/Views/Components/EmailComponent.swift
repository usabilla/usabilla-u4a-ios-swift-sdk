//
//  EmailComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class EmailComponent: BaseTextFieldComponent<EmailComponentViewModel> {
    override func build() {
        super.build()
        textField.keyboardType = .emailAddress
    }

    func updateBorderColor(email: String?) {
        let theme = viewModel.theme
        textField.layer.borderColor = viewModel.isValid ? theme.colors.hint.cgColor : theme.colors.error.cgColor
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        updateBorderColor(email: textField.text)
    }
}
