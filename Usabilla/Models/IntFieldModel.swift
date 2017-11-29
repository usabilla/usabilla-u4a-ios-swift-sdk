//
//  IntFieldModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class IntFieldModel: BaseFieldModel, Exportable {

    var fieldValue: Int?

    var exportableValue: Any? {
        return fieldValue
    }

    override var serialiazedValue: [String]? {
        guard let value = fieldValue else {
            return nil
        }
        return [String(value)]
    }

    override init(json: JSON) {
        fieldValue = nil
        super.init(json: json)
    }

    override func isValid() -> Bool {
        return !required || fieldValue != nil
    }

    override func reset() {
        fieldValue = nil
    }
}
