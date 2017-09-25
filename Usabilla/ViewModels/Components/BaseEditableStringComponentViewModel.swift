//
//  BaseEditableStringComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseEditableStringComponentViewModel<T: EditableStringComponentModel> : BaseStringComponentViewModel<T>, EditableStringComponentViewModel {
    var placeHolder: String? {
        return model.placeHolder
    }
}
