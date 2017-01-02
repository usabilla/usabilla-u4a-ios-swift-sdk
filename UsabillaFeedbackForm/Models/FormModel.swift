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
    init(appId: String, hasScreenshot: Bool, version: Int, pages: [PageModel], jsonString: JSON, themeConfig: UsabillaThemeConfigurator, redirectToAppStore: Bool?, showProgressBar: Bool?, copyModel:CopyModel ) {
        self.copyModel = copyModel
        self.hasScreenshot = hasScreenshot
        self.version = version
        self.pages = pages
        self.appId = appId
        self.formJsonString = jsonString
        self.themeConfig = themeConfig
        self.redirectToAppStore = redirectToAppStore != nil ? redirectToAppStore! : false
        self.showProgressBar = showProgressBar != nil ? showProgressBar! : true
    }

//    deinit {
//        print("called form model deinit")
//        print("containing \(pages.count) pages")
//
//    }
}
