//
//  PickerFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class PickerFieldModel: OptionsFieldModel {
    let defaultValue: String?
    let emptyValue: String?
    var expanded: Bool = false

    override var exportableValue: Any? {
        return isPickerValueValid() ? fieldValue : nil
    }

    override init(json: JSON, pageModel: PageModel) {
        defaultValue = json["default"].string
        emptyValue = json["empty"].string
        super.init(json: json, pageModel: pageModel)

        if let value = defaultValue {
            fieldValue = [value]
        }
        if let empty = emptyValue, !empty.isEmpty {
            options.insert(Options(title: empty, value: ""), at: 0)
        }
    }

    func isPickerValueValid() -> Bool {
        guard let first = fieldValue.first else {
            return false
        }
        return !fieldValue.isEmpty && !first.isEmpty
    }

    override func isValid() -> Bool {
        return !required || isPickerValueValid()
    }
}
