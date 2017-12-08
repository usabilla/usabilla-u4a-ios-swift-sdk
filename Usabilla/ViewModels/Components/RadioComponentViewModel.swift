//
//  RadioComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class RadioComponentViewModel: BaseOptionsComponentViewModel<RadioFieldModel> {

    override var accessibilityLabelDetail: String? {
        get {
            return "Choose from \(model.options.count) options, One option possible"
        }
        set {
            self.accessibilityLabelDetail = newValue
        }
    }
}
