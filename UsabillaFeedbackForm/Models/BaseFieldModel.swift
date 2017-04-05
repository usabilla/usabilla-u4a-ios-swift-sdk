//
//  BaseFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseFieldModel: FieldModelProtocol, ComponentModel {

    var isViewCurrentlyVisible = false
    unowned var pageModel: PageModel
    var theme: UsabillaTheme
    var fieldId: String
    var fieldTitle: String
    var required: Bool
    var isModelValid: Bool = true
    var type: String
    var rule: ShowHideRule?

    init(json: JSON, pageModel: PageModel) {
        self.pageModel = pageModel
        self.type = json["type"].stringValue
        self.fieldId = json["name"].stringValue
        self.fieldTitle = json["title"].stringValue
        self.required = json["required"].boolValue
        self.rule = nil
        self.theme = pageModel.theme
    }

    func convertToJSON() -> Any? {
        return nil
    }

    func isValid() -> Bool {
        isModelValid = false
        return false
    }

    func shouldAppear() -> Bool {
        if rule == nil {
            return true
        }
        let satisfied = rule!.isSatisfied()
        return satisfied && rule!.showIfRuleIsSatisfied || !satisfied && !rule!.showIfRuleIsSatisfied
    }

}
