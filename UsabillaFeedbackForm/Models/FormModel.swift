//
//  FormModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 03/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class FormModel {

    let appTitle: String
    let appSubmitButton: String
    let hasScreenshot: Bool
    let version: Int
    var pages: [PageModel]
    let appId: String
    var isDefault: Bool = false
    let formJsonString: JSON!
    let errorMessage: String
    
    init(appId: String, appTitle: String, appSubmitButton: String, hasScreenshot: Bool, version: Int, pages: [PageModel], jsonString: JSON, errorMessage: String) {
        self.errorMessage = errorMessage
        self.appTitle = appTitle
        self.appSubmitButton = appSubmitButton
        self.hasScreenshot = hasScreenshot
        self.version = version
        self.pages = pages
        self.appId = appId
        self.formJsonString = jsonString
    }
    
//    deinit {
//        print("called form model deinit")
//        print("containing \(pages.count) pages")
//        
//    }
}
