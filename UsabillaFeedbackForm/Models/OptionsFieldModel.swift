//
//  OptionsFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class OptionsFieldModel: BaseFieldModel {
    
    override var isViewCurrentlyVisible: Bool {
        didSet {
            if isViewCurrentlyVisible == false {
                fieldValue = []
            }
        }
    }
    
    
    let options: [Options]
    var fieldValue: [String] = [] {
        didSet {
            pageModel.fieldValuesCollection[fieldId] = fieldValue
        }
    }
    
    required init(json: JSON, pageModel: PageModel) {
        var options: [Options] = []
        for (_, subJson):(String, JSON) in json["options"] {
            options.append(Options(title: subJson["title"].stringValue, value: subJson["value"].stringValue))
        }
        self.options = options
        super.init(json: json, pageModel: pageModel)
        //self.isViewCurrentlyVisible = false
        
    }
    
    override func isValid() -> Bool {
        isModelValid =  !isViewCurrentlyVisible || !required || fieldValue.count > 0
        return isModelValid
    }
    
    override func convertToJSON() -> Any? {
        return fieldValue.count > 0 ? fieldValue : nil
    }

}