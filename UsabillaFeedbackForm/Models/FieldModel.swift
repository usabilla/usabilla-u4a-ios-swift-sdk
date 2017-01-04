//
//  FieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

protocol FieldModelProtocol {

    var isViewCurrentlyVisible: Bool {set get}
    unowned var themeConfig: UsabillaThemeConfigurator {get set}
    unowned var pageModel: PageModel {set get}
    var fieldId: String {set get}
    var fieldTitle: String {set get}
    var required: Bool {set get}

    var type: String {set get}
    var rule: ShowHideRule? {set get}
    var isModelValid: Bool {set get}

    init(json: JSON, pageModel: PageModel)

    func isValid() -> Bool
    func convertToJSON() -> Any?
}


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

//    deinit {
//        print("called basefieldmodel deinit")
//    }

}


class StringFieldModel: BaseFieldModel {

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

    required init(json: JSON, pageModel: PageModel) {
        fieldValue = nil
        super.init(json: json, pageModel: pageModel)
        //self.isViewCurrentlyVisible = false
    }


    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || (fieldValue != nil && fieldValue!.characters.count > 0)
        return isModelValid
    }

    override func convertToJSON() -> Any? {
        return fieldValue
    }
}


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
            if fieldValue != nil {
                pageModel.fieldValuesCollection[fieldId] = [String(fieldValue!)]
            }
        }
    }

    required init(json: JSON, pageModel: PageModel) {
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

class FieldModelWithOptions: BaseFieldModel {

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

//    deinit {
//        print("model with options deinit")
//    }
}


struct Options {

    let title: String
    let value: String

    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
