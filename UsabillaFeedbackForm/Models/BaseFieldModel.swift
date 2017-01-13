//
//  BaseFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseFieldModel: FieldModelProtocol {
    
    var isViewCurrentlyVisible = false
    unowned var pageModel: PageModel
    unowned var themeConfig: UsabillaThemeConfigurator
    var fieldId: String
    var fieldTitle: String
    var required: Bool
    var isModelValid: Bool = true
    var type: String
    var rule: ShowHideRule?
    
    required init(json: JSON, pageModel: PageModel) {
        self.pageModel = pageModel
        self.type = json["type"].stringValue
        self.fieldId = json["name"].stringValue
        self.fieldTitle = json["title"].stringValue
        self.required = json["required"].boolValue
        self.rule = nil
        self.themeConfig = pageModel.themeConfig
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
        } else {
            let satisfied = rule!.isSatisfied()
            return satisfied && rule!.showIfRuleIsSatisfied || !satisfied && !rule!.showIfRuleIsSatisfied
        }
    }
    
}
