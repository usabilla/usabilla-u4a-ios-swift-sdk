//
//  PageModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

enum PageType: String {
    case banner
    case start
    case form
    case end
    case toast

    var final: Bool {
        return self == .end || self == .toast
    }
}

class PageModel: PageModelProtocol {

    var fields: [BaseFieldModel]
    var fieldValuesCollection: [String: [String]] = [:] {
        didSet {
            SwiftEventBus.postToMainThread("pageUpdatedValues", sender: self)
        }
    }

    let pageNumber: Int?
    let pageName: String?
    let type: PageType
    var isLastPage: Bool?
    var jumpRuleList: [JumpRule]?
    var defaultJumpTo: String?
    var errorMessage: String?
    weak var copy: CopyModel?

    required init(pageNumber: Int, pageName: String, type: PageType) {
        self.pageNumber = pageNumber
        self.pageName = pageName
        errorMessage = nil
        fields = []
        self.type = type
        isLastPage = nil
        jumpRuleList = nil
        defaultJumpTo = nil
    }

    func toDictionary() -> [String: Any?] {
        var pageDictionary: [String: Any?] = [:]
        for field in fields where field.fieldID.characters.count > 0 && field is Exportable {
            let exportable = field as? Exportable
            pageDictionary[field.fieldID] = exportable?.exportableValue
        }
        return pageDictionary
    }
}
