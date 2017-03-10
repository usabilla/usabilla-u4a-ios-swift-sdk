//
//  FormModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 03/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class FormModel {


    let hasScreenshot: Bool
    let version: Int
    let pages: [PageModel]
    let appId: String
    var isDefault: Bool = false
    let formJsonString: JSON!
    let redirectToAppStore: Bool
    let showProgressBar: Bool
    let themeConfig: UsabillaThemeConfigurator
    let copyModel: CopyModel


    // swiftlint:disable:next function_parameter_count
    init(appId: String, hasScreenshot: Bool, version: Int, pages: [PageModel], jsonString: JSON, themeConfig: UsabillaThemeConfigurator, redirectToAppStore: Bool?, showProgressBar: Bool?, copyModel: CopyModel) {
        self.copyModel = copyModel
        self.hasScreenshot = hasScreenshot
        self.version = version
        self.pages = pages
        self.appId = appId
        self.formJsonString = jsonString
        self.themeConfig = themeConfig
        self.redirectToAppStore = redirectToAppStore != nil ? redirectToAppStore! : false
        self.showProgressBar = showProgressBar != nil ? showProgressBar! : true

        _ = pages.map { $0.copy = copyModel }
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
            type(of: $0) == StarFieldModel.self || type(of: $0) == MoodFieldModel.self
        } as? IntFieldModel
        let ratingValue = rating?.fieldValue
        
        if pages[latestPageIndex].type != .end {
            return FeedbackResult(rating: ratingValue, abandonedPageIndex: latestPageIndex)
        }
        return FeedbackResult(rating: ratingValue, abandonedPageIndex: nil)
    }

}
