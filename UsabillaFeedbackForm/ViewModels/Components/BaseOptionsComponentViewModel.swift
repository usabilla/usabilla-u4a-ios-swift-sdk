//
//  BaseOptionsComponentViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 14/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseOptionsComponentViewModel<T: OptionsFieldModel>: BaseComponentViewModel<[String], OptionsFieldModel>, OptionsComponentViewModel {
    var options: [Options] {
        get {
            return model.options
        }
    }
    override var value: [String]? {
        get {
            return model.fieldValue
        }
        set {
            model.fieldValue = newValue != nil ? newValue! : []
        }
    }
}

