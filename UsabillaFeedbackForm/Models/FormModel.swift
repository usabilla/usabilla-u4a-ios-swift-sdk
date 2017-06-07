//
//  FormModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 03/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class FormModel: NSObject, NSCoding {

    let hasScreenshot: Bool
    let version: Int
    let pages: [PageModel]
    let appId: String
    var isDefault: Bool = false
    let formJsonString: JSON
    let redirectToAppStore: Bool
    let showProgressBar: Bool
    var theme: UsabillaTheme
    let copyModel: CopyModel

    // swiftlint:disable:next function_parameter_count
    init(appId: String, hasScreenshot: Bool, version: Int, pages: [PageModel], jsonString: JSON, redirectToAppStore: Bool?, showProgressBar: Bool?, copyModel: CopyModel) {
        self.copyModel = copyModel
        self.hasScreenshot = hasScreenshot
        self.version = version
        self.pages = pages
        self.appId = appId
        self.formJsonString = jsonString
        self.theme = UsabillaFeedbackForm.theme
        self.redirectToAppStore = redirectToAppStore != nil ? redirectToAppStore! : false
        self.showProgressBar = showProgressBar != nil ? showProgressBar! : true

        _ = pages.map { $0.copy = copyModel }
    }

    init(json: JSON, id: String, screenshot: UIImage?) {
        let data = json["data"]
        self.copyModel = CopyModel(json: json)
        self.hasScreenshot = data["screenshot"].boolValue
        self.version = json["version"].intValue
        self.redirectToAppStore = data["appStoreRedirect"].boolValue
        self.showProgressBar = data["progressBar"].bool ?? true
        self.appId = id
        self.formJsonString = json
        self.theme = UsabillaTheme()

        var newPages: [PageModel] = []
        let structure: [String: JSON] = json["form"].dictionary ?? json["structure"].dictionary ?? [String: JSON]()
        let pages: JSON = JSON(structure)["pages"]
        for (index, subJson): (String, JSON) in pages {
            let page = JSONFormParser.parsePage(subJson, pageNum: Int(index)!)
            page.errorMessage = copyModel.errorMessage
            page.copy = copyModel
            newPages.append(page)
        }
        newPages.last?.isLastPage = true
        var screenshotJson: [String: Any] = [:]
        screenshotJson["type"] = "screenshot"
        screenshotJson["name"] = "screenshot"
        screenshotJson["title"] = "Screenshot"
        screenshotJson["required"] = false

        let pageModel = newPages.first
        if hasScreenshot {
            newPages.first?.fields.append(ScreenshotModel(json: JSON(screenshotJson), pageModel: pageModel!, screenShot: screenshot))
        }

        self.pages = newPages
    }

    func toDictionnary() -> [String: Any] {
        var formDictionary = [String: Any]()
        let indexToStop = pages.count - 1
        for index in 0...indexToStop - 1 {
            let page = pages[index]
            for field in page.fields {
                if let converted = field.convertToJSON() {
                    if field.fieldId.characters.count > 0 {
                        formDictionary[field.fieldId] = converted
                    }
                }
            }
        }
        return formDictionary
    }

    /**
        Create a FeedbackResult based on the currentState of the form
        
        - parameter latestPageIndex: the higher page index of the form that has been shown to the user (starting from 0)
        - returns : FeedbackResult matching the input parameters
     
          If **latestPageIndex** is lower than the last pages number the abandonnedPageIndex is set to the latestPageIndex
          ise it returns a FeedbackResult witht the rating of the form if there is one.
    */
    func toFeedbackResult(latestPageIndex: Int) -> FeedbackResult {
        let rating = pages.first?.fields.first {
            type(of: $0) == MoodFieldModel.self
        } as? IntFieldModel
        let ratingValue = rating?.fieldValue

        if pages[latestPageIndex].type != .end {
            return FeedbackResult(rating: ratingValue, abandonedPageIndex: latestPageIndex)
        }
        return FeedbackResult(rating: ratingValue, abandonedPageIndex: nil)
    }

    func updateTheme() {
        self.theme.updateConfig(json: formJsonString["colors"])
    }

    // MARK: NScoding protocols

    // swiftlint:disable force_cast
    public required convenience init?(coder aDecoder: NSCoder) {
        let appId = aDecoder.decodeObject(forKey: "appId") as! String
        let rawJson = aDecoder.decodeObject(forKey: "formJsonString")
        let formJsonString = JSON(rawJson!)

        self.init(json: formJsonString, id: appId, screenshot: nil)
    }

    // swiftlint:enable force_cast
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(appId, forKey: "appId")
        aCoder.encode(formJsonString.rawValue, forKey: "formJsonString")
    }
}
