//
//  PickerComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class PickerComponentViewModel: BaseComponentViewModel<String, PickerFieldModel> {
    var expanded: Bool = false
    var options: [Options] {
        return model.options
    }

    override var value: String? {
        get {
            return model.fieldValue.first
        }
        set {
            // swiftlint:disable:next force_unwrapping
            model.fieldValue = newValue != nil ? [newValue!] : []
        }
    }

    var pickerButtonTitle: String? {

        //If it exists, select the value the user selected before
        if let tmpValue = value {
            // swiftlint:disable:next force_unwrapping
            return options.first(where: { $0.value == tmpValue })!.title
        }

        //If no value is present, try use the empty state button
        if let emptyButtonText = model.emptyValue {
            return emptyButtonText
        }

        return nil
    }

    var indexOfSelectedOption: Int? {

        //If it exists, select the value the user selected before
        if let tmpValue = value {
            return options.index(where: { $0.value == tmpValue })
        }

        return nil
    }
}
