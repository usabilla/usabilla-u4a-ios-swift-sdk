//
//  JSONFormParser.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 03/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class JSONFormParser {

    static func getStructureHolder(inJSON json: JSON) -> JSON {
        return json["structure"].exists() ? json["structure"] : json
    }

    class func checkForContinueButton(pageJson: JSON) -> Bool {
        let continueField = pageJson["fields"].arrayValue.first { $0["type"].stringValue == "continue" }
        guard let field = continueField, !field["title"].stringValue.isEmpty else {
            return false
        }
        return true
    }

    class func parsePage(_ pageJson: JSON, pageNum: Int) -> PageModel {

        let pageName = pageJson["name"].stringValue
        // swiftlint:disable:next force_unwrapping
        let type = PageType(rawValue: pageJson["type"].stringValue)!

        var pageModelClass: PageModel.Type

        switch type {
        case .start, .banner:
            pageModelClass = IntroPageModel.self
        case .form:
            pageModelClass = PageModel.self
        case .end, .toast:
            pageModelClass = UBEndPageModel.self
        }
        let currentPage = pageModelClass.init(pageNumber: pageNum, pageName: pageName, type: type)
        currentPage.defaultJumpTo = pageJson["jump"].string

        // specific intro page parsing
        if let introPage = currentPage as? IntroPageModel {
            //look for continue field
            introPage.hasContinueButton = checkForContinueButton(pageJson: pageJson)
            if let displayMode = IntroPageDisplayMode(rawValue: pageJson["display"].stringValue) {
                introPage.displayMode = displayMode
            }
        }

        if let endPage = currentPage as? UBEndPageModel {
            endPage.giveMoreFeedback = !UsabillaInternal.hideGiveMoreFeedback
        }

        var fields: [BaseFieldModel] = []

        for (_, subJson): (String, JSON) in pageJson["fields"] {
            if let newField = parseFieldModel(subJson, pagemodel: currentPage) {
                fields.append(newField)
            }
        }

        currentPage.fields = fields

        if pageJson["jumpRules"].exists() {
            var jumpRules: [JumpRule] = []

            for (_, subJson): (String, JSON) in pageJson["jumpRules"] {
                jumpRules.append(parseJumpRule(subJson, pageModel: currentPage))
            }
            currentPage.jumpRuleList = jumpRules
        }
        return currentPage

    }

    fileprivate class func parseJumpRule(_ jumpJson: JSON, pageModel: PageModel) -> JumpRule {

        let setDependsOnID = jumpJson["control"].stringValue
        let setJumpTo = jumpJson["jump"].stringValue

        var values: [String] = []
        for (_, subJson): (String, JSON) in jumpJson["value"] {
            values.append(subJson.stringValue)
        }

        return JumpRule(jumpTo: setJumpTo, dependsOnID: setDependsOnID, targetValues: values, pageModel: pageModel)
    }

    fileprivate class func parseFieldModel(_ json: JSON, pagemodel: PageModel) -> BaseFieldModel? {

        if let field: BaseFieldModel = FieldFactory.createField(json, pagemodel: pagemodel) {
            if json["showHideRule"].exists() && !json["showHideRule"].isEmpty {
                field.rule = parseShowHideRule(json["showHideRule"], pageModel: pagemodel)
            }
            return field
        }
        return nil
    }

    fileprivate class func parseShowHideRule(_ json: JSON, pageModel: PageModel) -> ShowHideRule {

        let setDependsOnID = json["control"].stringValue

        var values: [String] = []
        for (_, subJson): (String, JSON) in json["value"] {
            values.append(subJson.stringValue)
        }

        //Set the default behaviour
        let setShowIfRuleIsSatisfied: Bool = json["action"].stringValue == "show"

        return ShowHideRule(dependsOnID: setDependsOnID, targetValues: values, pageModel: pageModel, show: setShowIfRuleIsSatisfied)
    }

}
