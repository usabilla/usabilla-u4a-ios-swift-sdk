//
//  IntFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class IntFieldModel: BaseFieldModel, Exportable {

    var fieldValue: Int? {
        didSet {
            if let value = fieldValue {
                pageModel.fieldValuesCollection[fieldId] = [String(value)]
                return
            }
            pageModel.fieldValuesCollection.removeValue(forKey: fieldId)
        }
    }

    var exportableValue: Any? {
        return fieldValue
    }

    override init(json: JSON, pageModel: PageModel) {
        fieldValue = nil
        super.init(json: json, pageModel: pageModel)
    }

    override func isValid() -> Bool {
        return !required || fieldValue != nil
    }

    override func reset() {
        fieldValue = nil
    }
}
