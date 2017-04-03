//
//  JSONFormParser.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 03/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class JSONFormParser {

    class func parsePage(_ pageJson: JSON, pageNum: Int, themeConfig: UsabillaThemeConfigurator) -> PageModel {

        let pageName = pageJson["name"].stringValue
        let type = PageType(rawValue: pageJson["type"].stringValue)

        let pageModelClass: PageModel.Type = type != .start ? PageModel.self : IntroPageModel.self
        let currentPage = pageModelClass.init(pageNumber: pageNum, pageName: pageName, themeConfig: themeConfig)
        currentPage.defaultJumpTo = pageJson["jump"].string
        currentPage.type = type

        // specific intro page parsing
        if let introPage = currentPage as? IntroPageModel {
            introPage.hasContinueButton = pageJson["hasContinueButton"].boolValue
            if let displayMode = IntroPageDisplayMode(rawValue: pageJson["display"].stringValue) {
                introPage.displayMode = displayMode
            }
        }

        var fields: [BaseFieldModel] = []

        for (_, subJson): (String, JSON) in pageJson["fields"] {
            //print("parsing field \(index) of page \(pageNum)")
            if let newField = parseFieldModel(subJson, pagemodel: currentPage) {
                fields.append(newField)
            }
            //print("fields now has \(fields.count) elements")
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

    fileprivate class func parseColors(_ config: UsabillaThemeConfigurator, json: JSON) {
        if let titleColorHex = json["group1"]["hash"].string {
            config.titleColor = UIColor(rgba: titleColorHex)
        }
        if let accentColorHex = json["group2"]["hash"].string {
            config.accentColor = UIColor(rgba: accentColorHex)
        }
        if let textColorHex = json["group3"]["hash"].string {
            config.textColor = UIColor(rgba: textColorHex)
        }
        if let errorColorHex = json["group4"]["hash"].string {
            config.errorColor = UIColor(rgba: errorColorHex)
        }
        if let backgroundColorHex = json["group5"]["hash"].string {
            config.backgroundColor = UIColor(rgba: backgroundColorHex)
        }
        if let textOnAccentHex = json["group6"]["hash"].string {
            config.textOnAccentColor = UIColor(rgba: textOnAccentHex)
        }
    }
}
