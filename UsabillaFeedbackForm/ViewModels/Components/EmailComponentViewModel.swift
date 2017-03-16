//
//  EmailComponentViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 14/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class EmailComponentViewModel: BaseEditableStringComponentViewModel<EmailFieldModel> {
    var isValid: Bool {
        guard let email = value else {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
