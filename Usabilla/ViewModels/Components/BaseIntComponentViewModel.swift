//
//  BaseIntComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 14/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseIntComponentViewModel<M: IntFieldModel>: BaseComponentViewModel<Int, M> {
    override var value: Int? {
        get {
            return model.fieldValue
        }
        set {
            model.fieldValue = newValue
            delegate?.valueDidChange()
        }
    }
}
