//
//  BaseFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseFieldModel: FieldModelProtocol, ComponentModel {

    unowned var pageModel: PageModel
    var fieldId: String
    var fieldTitle: String
    var required: Bool
    var type: String
    var rule: ShowHideRule?

    init(json: JSON, pageModel: PageModel) {
        self.pageModel = pageModel
        self.type = json["type"].stringValue
        self.fieldId = json["name"].stringValue
        self.fieldTitle = json["title"].stringValue
        self.required = json["required"].boolValue
        self.rule = nil
    }

    func convertToJSON() -> Any? {
        return nil
    }

    /**
    Reset the model value to a nil or empty value
    */
    func reset() {
        fatalError("reset has not been implemented")
    }

    func isValid() -> Bool {
        return false
    }

    func shouldAppear() -> Bool {
        if let rule = rule {
            let satisfied = rule.isSatisfied()
            return satisfied && rule.showIfRuleIsSatisfied || !satisfied && !rule.showIfRuleIsSatisfied
        }
        return true
    }
}
