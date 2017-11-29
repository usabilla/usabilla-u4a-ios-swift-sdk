//
//  StringFieldModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class StringFieldModel: BaseFieldModel, StringComponentModel {
    var fieldValue: String?

    override var serialiazedValue: [String]? {
        guard let value = fieldValue else {
            return nil
        }
        return [value]
    }

    override init(json: JSON) {
        fieldValue = nil
        super.init(json: json)
    }

    override func isValid() -> Bool {
        guard let value = fieldValue else {
            return !required
        }
        return !required || !value.isEmpty
    }

    override func reset() {
        fieldValue = nil
    }
}
