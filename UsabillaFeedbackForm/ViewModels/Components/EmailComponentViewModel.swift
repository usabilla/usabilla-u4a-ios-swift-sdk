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
        return model.isValidEmail(testStr: email)
    }
}
