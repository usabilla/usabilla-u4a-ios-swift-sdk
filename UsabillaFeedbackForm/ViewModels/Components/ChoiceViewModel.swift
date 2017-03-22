//
//  ChoiceViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class ChoiceComponentViewModel: BaseComponentViewModel<String, ChoiceFieldModel> {
    var expanded: Bool = false
    var options: [Options] {
        return model.options
    }
    
    override var value: String? {
        get {
            return model.fieldValue.first
        }
        set {
            model.fieldValue = newValue != nil ? [newValue!] : []
        }
    }
}
