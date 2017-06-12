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
    var type: PageType?
    var isLastPage: Bool?
    var jumpRuleList: [JumpRule]?
    var defaultJumpTo: String?
    var errorMessage: String?
    weak var copy: CopyModel?

    required init(pageNumber: Int, pageName: String) {
        self.pageNumber = pageNumber
        self.pageName = pageName
        errorMessage = nil
        fields = []
        type = nil
        isLastPage = nil
        jumpRuleList = nil
        defaultJumpTo = nil
    }

    func toJSONDictionary() -> [String: Any] {
        var formDictionary: [String: Any] = [:]
        for field in fields {
            if let converted = field.convertToJSON() {
                if field.fieldId.characters.count > 0 {
                    formDictionary[field.fieldId] = converted
                }
            }
        }
        return formDictionary
    }
}
