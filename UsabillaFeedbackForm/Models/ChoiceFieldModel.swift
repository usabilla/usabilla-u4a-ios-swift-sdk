//
//  ChoiceFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class ChoiceFieldModel: OptionsFieldModel {
    let defaultValue: String?
    let emptyValue: String?
    var expanded: Bool = false

    override init(json: JSON, pageModel: PageModel) {
        defaultValue = json["default"].string
        emptyValue = json["empty"].string
        super.init(json: json, pageModel: pageModel)

        if let value = defaultValue {
            fieldValue = [value]
        }
        if let empty = emptyValue {
            //I hate our backend
            if !empty.isEmpty {
                options.insert(Options(title: empty, value: ""), at: 0)
            }
        }
    }

    func isChoiceValueValid() -> Bool {
        return !fieldValue.isEmpty && !fieldValue.first!.isEmpty
    }

    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || isChoiceValueValid()
        return isModelValid
    }

    override func convertToJSON() -> Any? {
        return isChoiceValueValid() ? fieldValue : nil
    }
}
