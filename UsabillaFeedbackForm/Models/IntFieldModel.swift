//
//  IntFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation


class IntFieldModel: BaseFieldModel {

    var fieldValue: Int? {
        didSet {
            if let value = fieldValue {
                pageModel.fieldValuesCollection[fieldId] = [String(value)]
            } else {
                pageModel.fieldValuesCollection[fieldId] = nil
            }
        }
    }

    override init(json: JSON, pageModel: PageModel) {
        fieldValue = nil
        super.init(json: json, pageModel: pageModel)
    }

    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || fieldValue != nil
        return isModelValid
    }

    override func convertToJSON() -> Any? {
        return fieldValue
    }

    override func reset() {
        fieldValue = nil
    }

}
