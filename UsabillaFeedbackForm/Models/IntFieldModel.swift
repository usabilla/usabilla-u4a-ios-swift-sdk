//
//  IntFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation


class IntFieldModel: BaseFieldModel {

    override var isViewCurrentlyVisible: Bool {
        didSet {
            if isViewCurrentlyVisible == false {
                fieldValue = nil
            }
        }
    }

    var fieldValue: Int? {
        didSet {
            if let value = fieldValue {
                pageModel.fieldValuesCollection[fieldId] = [String(value)]
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

}
