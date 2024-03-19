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
    var client: ClientModel?

    init(identifier: String, hasScreenshot: Bool, version: Int, pages: [PageModel], jsonString: JSON, redirectToAppStore: Bool, showProgressBar: Bool?, copyModel: CopyModel, maskModel: MaskModel?, client: ClientModel? = nil) {
        self.copyModel = copyModel
        self.hasScreenshot = hasScreenshot
        self.version = version
        self.pages = pages
        self.identifier = identifier
        self.formJsonString = jsonString
        self.theme = UsabillaInternal.theme
        self.showProgressBar = showProgressBar ?? true
        self.redirectToAppStore = redirectToAppStore
        _ = pages.map { $0.copy = copyModel }
        self.client = client
    }

    init?(json: JSON, id: String, screenshot: UIImage?, maskModel: MaskModel?, client: ClientModel? = nil) {
        let jsonHolder = JSONFormParser.getStructureHolder(inJSON: json)
        guard let form = jsonHolder["form"].dictionary,
            let formPages = form["pages"] else {
                return nil
        }

        let data = jsonHolder[JSONConstant.data]
        self.copyModel = CopyModel(json: jsonHolder)
        self.version = json[JSONConstant.Data.version].intValue
        self.identifier = id
        self.formJsonString = json
        self.theme = UsabillaTheme()
        // campaigns return json where progressBar is lowercase all lowercase ~ progressbar
        // forms return json where progressBar has the B capitalized ~ progressBar
        // until backend makes a choice we have to have both
        self.showProgressBar = data[JSONConstant.Data.progressBar].bool ?? data[JSONConstant.Data.progressBar.lowercased()].bool ?? false
        self.hasScreenshot = data[JSONConstant.Data.screenShot].boolValue
        self.redirectToAppStore = data[JSONConstant.Data.appStoreRedirect].boolValue

        var newPages: [PageModel] = []

        for (index, subJson): (String, JSON) in formPages {
            if let index = Int(index) {
                let page = JSONFormParser.parsePage(subJson, pageNum: index, maskModel: maskModel)
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

        self.client = client

        if let firstPageModel = newPages.first, hasScreenshot {
            let screenshotModel = ScreenshotModel(json: JSON(screenshotJson), screenShot: screenshot)
            firstPageModel.fields.append(screenshotModel)
            var imageTypeDict = ["image_type": nil as Any?, "number_of_drawings": nil]
            if screenshot != nil {
             imageTypeDict = ["image_type": "default", "number_of_drawings": nil]
            }
            self.client?.addBehaviour("screenshot_annotations", imageTypeDict)
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

    func toJson() throws -> Data {
        let jsonData = try JSONSerialization.data(withJSONObject: toDictionary(), options: [])
        return jsonData
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
        let colors = jsonHolder["colors"]
        let darkMode = jsonHolder["data"]["darkMode"] != nil
        if darkMode {
            // swiftlint:disable force_cast
            let darkModeEnabled = jsonHolder["data"]["darkMode"].rawValue as! Bool
            if darkModeEnabled {
                let darkColors = jsonHolder["darkColors"]
                self.theme.updateDarkColors(lightModeColors: colors, darkModeColors: darkColors)
            } else {
                self.theme.updateColors(json: colors)
            }
        } else {
            self.theme.updateColors(json: colors)
        }
    }

    func addScrenshot(image: UIImage?) {
        guard let screenShotImage = image else {
            return
        }
        var imageAdded = false
        pages.forEach {
            $0.fields.forEach {
                if let model = $0 as? ScreenshotModel {
                    model.image = screenShotImage
                    imageAdded = true
                }
            }
        }
        if !imageAdded {
            Swift.debugPrint("Usabilla: failed adding a provided screenshot image to the store form, as no screenshot module was found on the form")
        }
    }
    // MARK: NScoding protocols

    required convenience init?(coder aDecoder: NSCoder) {
        guard let identifier = aDecoder.decodeObject(forKey: "identifier") as? String,
            let rawJson = aDecoder.decodeObject(forKey: "formJsonString") else {
                return nil
        }
        self.init(json: JSON(rawJson), id: identifier, screenshot: nil, maskModel: nil)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: "identifier")
        aCoder.encode(formJsonString.rawValue, forKey: "formJsonString")
    }
}
