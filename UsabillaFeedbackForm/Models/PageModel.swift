//
//  PageModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

enum PageType: String {
    case form
    case end
}

class PageModel {

    var fields: [BaseFieldModel]
    var fieldValuesCollection: [String: [String]] = [:] {
        didSet {
            SwiftEventBus.postToMainThread("pageUpdatedValues", sender: self)
        }
    }

    let pageNumber: Int?
    let pageName: String?
    var type: PageType?
    var isLastPage: Bool?
    var jumpRuleList: [JumpRule]?
    var defaultJumpTo: String?
    var errorMessage: String?
    let themeConfig: UsabillaThemeConfigurator
    weak var copy: CopyModel?

    init(pageNumber: Int, pageName: String, themeConfig: UsabillaThemeConfigurator) {
        self.pageNumber = pageNumber
        self.pageName = pageName
        errorMessage = nil
        fields = []
        type = nil
        isLastPage = nil
        jumpRuleList = nil
        defaultJumpTo = nil
        self.themeConfig = themeConfig
    }

//    deinit {
//        print("called page model \(pageName) , \(pageNumber) deinit")
//        print("containing \(fields.count) fields")
//    }
}
