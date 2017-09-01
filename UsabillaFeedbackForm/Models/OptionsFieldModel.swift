//
//  OptionsFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class OptionsFieldModel: BaseFieldModel, Exportable {

    var options: [Options]
    var fieldValue: [String] = [] {
        didSet {
            if fieldValue.count > 0 {
                pageModel.fieldValuesCollection[fieldID] = fieldValue
                return
            }
            pageModel.fieldValuesCollection.removeValue(forKey: fieldID)
        }
    }

    var exportableValue: Any? {
        return fieldValue.count > 0 ? fieldValue : nil
    }

    override init(json: JSON, pageModel: PageModel) {
        var options: [Options] = []
        for (_, subJson): (String, JSON) in json["options"] {
            options.append(Options(title: subJson["title"].stringValue, value: subJson["value"].stringValue))
        }
        self.options = options
        super.init(json: json, pageModel: pageModel)
    }

    override func isValid() -> Bool {
        return !required || fieldValue.count > 0
    }

    override func reset() {
        fieldValue = []
    }
}
