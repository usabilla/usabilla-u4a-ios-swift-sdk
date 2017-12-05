//
//  CheckBoxComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CheckBoxComponentViewModel: BaseOptionsComponentViewModel<CheckboxFieldModel> {

    override var accessibilityLabel: String? {
        get {
            return "Choose from \(model.options.count) options, Multiple options possible"
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
}
