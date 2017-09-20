//
//  FormModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 03/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class FormModel: NSObject, NSCoding {

    let hasScreenshot: Bool
    let version: Int
    let pages: [PageModel]
    let identifier: String
    let formJsonString: JSON
    let redirectToAppStore: Bool
    let showProgressBar: Bool
    var theme: UsabillaTheme
    let copyModel: CopyModel

    init(identifier: String, hasScreenshot: Bool, version: Int, pages: [PageModel], jsonString: JSON, redirectToAppStore: Bool, showProgressBar: Bool?, copyModel: CopyModel) {
        self.copyModel = copyModel
        self.hasScreenshot = hasScreenshot
        self.version = version
        self.pages = pages
        self.identifier = identifier
        self.formJsonString = jsonString
        self.theme = UsabillaFeedbackForm.theme
        self.showProgressBar = showProgressBar ?? true
        self.redirectToAppStore = redirectToAppStore
        _ = pages.map { $0.copy = copyModel }
    }

    init(json: JSON, id: String, screenshot: UIImage?) {

        let jsonHolder = JSONFormParser.getStructureHolder(inJSON: json)

        let data = jsonHolder["data"]
        let form = jsonHolder["form"]
        self.copyModel = CopyModel(json: jsonHolder)
        self.hasScreenshot = data["screenshot"].boolValue
        self.redirectToAppStore = data["appStoreRedirect"].boolValue
        self.version = json["version"].intValue
        self.showProgressBar = data["progressBar"].bool ?? true
        self.identifier = id
        self.formJsonString = json
        self.theme = UsabillaTheme()

        var newPages: [PageModel] = []

        for (index, subJson): (String, JSON) in form["pages"] {
            if let index = Int(index) {
                let page = JSONFormParser.parsePage(subJson, pageNum: index)
                page.errorMessage = copyModel.errorMessage
                page.copy = copyModel
                newPages.append(page)
            }
        }

        newPages.last?.isLastPage = true
        var screenshotJson: [String: Any] = [:]
        screenshotJson["type"] = "screenshot"
        screenshotJson["name"] = "screenshot"
        screenshotJson["title"] = copyModel.screenshotTitle
        screenshotJson["required"] = false

        if let firstPageModel = newPages.first, hasScreenshot {
            firstPageModel.fields.append(ScreenshotModel(json: JSON(screenshotJson), pageModel: firstPageModel, screenShot: screenshot))
        }

        self.pages = newPages
    }

    func toDictionary() -> [String: Any?] {
        var formDictionary = [String: Any?]()
        for page in pages {
            let pagePayload = page.toDictionary()
            pagePayload.forEach {
                formDictionary[$0.key] = $0.value
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
        let jsonHolder = JSONFormParser.getStructureHolder(inJSON: formJsonString)
        self.theme.updateColors(json: jsonHolder["colors"])
    }

    // MARK: NScoding protocols

    public required convenience init?(coder aDecoder: NSCoder) {
        guard let identifier = aDecoder.decodeObject(forKey: "identifier") as? String,
            let rawJson = aDecoder.decodeObject(forKey: "formJsonString") else {
                return nil
        }
        self.init(json: JSON(rawJson), id: identifier, screenshot: nil)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: "identifier")
        aCoder.encode(formJsonString.rawValue, forKey: "formJsonString")
    }
}
