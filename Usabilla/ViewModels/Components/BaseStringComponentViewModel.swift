//
//  BaseStringComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 14/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseStringComponentViewModel<M: StringComponentModel>: BaseComponentViewModel<String, M>, StringComponentViewModel {
    override var value: String? {
        get {
            return model.fieldValue
        }
        set {
            model.fieldValue = newValue
            delegate?.valueDidChange()
        }
    }
}
