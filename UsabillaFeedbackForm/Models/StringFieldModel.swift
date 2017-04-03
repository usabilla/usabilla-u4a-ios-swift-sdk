//
//  StringFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class StringFieldModel: BaseFieldModel, StringComponentModel {

    override var isViewCurrentlyVisible: Bool {
        didSet {
            if isViewCurrentlyVisible == false {
                fieldValue = nil
            }
        }
    }

    var fieldValue: String? {
        didSet {
            if fieldValue != nil {
                pageModel.fieldValuesCollection[fieldId] = [fieldValue!]
            }
        }
    }

    override init(json: JSON, pageModel: PageModel) {
        fieldValue = nil
        super.init(json: json, pageModel: pageModel)
    }

    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || (fieldValue != nil && fieldValue!.characters.count > 0)
        return isModelValid
    }

    override func convertToJSON() -> Any? {
        return fieldValue
    }
}
