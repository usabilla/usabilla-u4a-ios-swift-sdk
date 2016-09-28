//
//  JSONFormParser.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 03/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class JSONFormParser {

    class func parseFormJson(json: JSON, appId: String, screenshot: UIImage?, themeConfig: UsabillaThemeConfigurator) -> FormModel {

        let data = json["data"]
        let appTitle = data["appTitle"].stringValue
        let appSubmit = data["appSubmit"].stringValue
        let hasScreenshot = data["screenshot"].boolValue
        let version = json["version"].intValue
        let errorMessage = data["errorMessage"].stringValue
        let colorJson = json["colors"]
        parseColors(themeConfig, json: colorJson)

        var pages: [PageModel] = []

        for (index, subJson):(String, JSON) in json["form"]["pages"] {
            let page = parsePage(subJson, pageNum: Int(index)!, themeConfig: themeConfig)
            page.errorMessage = errorMessage
            pages.append(page)
        }
        pages.last?.isLastPage = true

        var screenshotJson: [String: AnyObject] = [:]
        screenshotJson["type"] = "screenshot"
        screenshotJson["name"] = "screenshot"
        screenshotJson["title"] = "Screenshot"
        screenshotJson["required"] = false

        let pageModel = pages.first
        if hasScreenshot {
            pages.first?.fields.append(ScreenshotModel(json: JSON(screenshotJson), pageModel: pageModel!, screenShot: screenshot))
        }
        
        return FormModel(appId: appId, appTitle: appTitle, appSubmitButton: appSubmit, hasScreenshot: hasScreenshot, version: version, pages: pages, jsonString: json, errorMessage : errorMessage, themeConfig:  themeConfig)
    }


    private class func parsePage(pageJson: JSON, pageNum: Int, themeConfig: UsabillaThemeConfigurator) -> PageModel {


        let pageName = pageJson["name"].stringValue
        let type = pageJson["type"].stringValue

        let currentPage = PageModel(pageNumber: pageNum, pageName: pageName, themeConfig: themeConfig)
        currentPage.defaultJumpTo = pageJson["jump"].string
        currentPage.type = type

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

            for (_, subJson):(String, JSON) in pageJson["jumpRules"] {
                jumpRules.append(parseJumpRule(subJson, pageModel: currentPage))
            }
            currentPage.jumpRuleList = jumpRules
        }
        return currentPage

    }


    private class func parseJumpRule(jumpJson: JSON, pageModel: PageModel) -> JumpRule {

        let setDependsOnID = jumpJson["control"].stringValue
        let setJumpTo = jumpJson["jump"].stringValue

        var values: [String] = []
        for (_, subJson):(String, JSON) in jumpJson["value"] {
            values.append(subJson.stringValue)
        }

        return JumpRule(jumpTo: setJumpTo, dependsOnID: setDependsOnID, targetValues: values, pageModel: pageModel)
    }


    private class func parseFieldModel(json: JSON, pagemodel: PageModel) -> BaseFieldModel? {

        if let field: BaseFieldModel = FieldFactory.createField(json, pagemodel: pagemodel) {

            if json["showHideRule"].exists() && !json["showHideRule"].isEmpty {
                field.rule =  parseShowHideRule(json["showHideRule"], pageModel: pagemodel)
            }
            //print("return field \(field)")
            return field
        } else {
            return nil
        }
    }

    private class func parseShowHideRule(json: JSON, pageModel: PageModel) -> ShowHideRule {

        let setDependsOnID = json["control"].stringValue

        var values: [String] = []
        for (_, subJson):(String, JSON) in json["value"] {
            values.append(subJson.stringValue)
        }

        //Set the default behaviour
        let setShowIfRuleIsSatisfied: Bool = json["action"].stringValue == "show"

        return ShowHideRule(dependsOnID: setDependsOnID, targetValues: values, pageModel: pageModel, show: setShowIfRuleIsSatisfied)
    }
    
    private class func parseColors(config: UsabillaThemeConfigurator, json: JSON){
        if let primaryTextColorHex = json["group1"]["hash"].string {
            config.primaryTextColor = UIColor(rgba: primaryTextColorHex)
        }
        if let headerColorHex = json["group2"]["hash"].string {
            config.headerColor = UIColor(rgba: headerColorHex)
        }
        if let headerTextColorHex = json["group3"]["hash"].string {
            config.headerTextColor = UIColor(rgba: headerTextColorHex)
        }
        if let accentColorHex = json["group4"]["hash"].string {
            config.accentColor = UIColor(rgba: accentColorHex)
        }
        if let textOnAccentColorHex = json["group5"]["hash"].string {
            config.textOnAccentColor = UIColor(rgba: textOnAccentColorHex)
        }
        if let hintColorHex = json["group6"]["hash"].string {
            config.hintColor = UIColor(rgba: hintColorHex)
        }
        if let errorColorHex = json["group7"]["hash"].string {
            config.errorColor = UIColor(rgba: errorColorHex)
        }
        if let backgroundColorHex = json["group8"]["hash"].string {
            config.backgroundColor = UIColor(rgba: backgroundColorHex)
        }
    }
}
