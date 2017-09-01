//
//  StringFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class StringFieldModel: BaseFieldModel, StringComponentModel {
    var fieldValue: String? {
        didSet {
            if let value = fieldValue {
                pageModel.fieldValuesCollection[fieldID] = [value]
                return
            }
            pageModel.fieldValuesCollection.removeValue(forKey: fieldID)
        }
    }

    override init(json: JSON, pageModel: PageModel) {
        fieldValue = nil
        super.init(json: json, pageModel: pageModel)
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
