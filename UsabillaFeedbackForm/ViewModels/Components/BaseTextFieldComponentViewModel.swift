//
//  BaseTextFieldComponentViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseTextFieldComponentViewModel<T: EditableStringComponentModel> : BaseStringComponentViewModel<T>, EditableStringComponentViewModel {
    var placeHolder: String? {
        return model.placeHolder
    }
}
