//
//  PageModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

enum PageType: String {
    case banner
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

    let pageName: String?
    let type: PageType
    var isLastPage: Bool?
    var jumpRuleList: [JumpRule]?
    var defaultJumpTo: String?
    var errorMessage: String?
    weak var copy: CopyModel?

    required init(pageName: String, type: PageType) {
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
        for field in fields where field.fieldID.count > 0 && field is Exportable {
            let exportable = field as? Exportable
            pageDictionary[field.fieldID] = exportable?.exportableValue
        }
        return pageDictionary
    }
}

extension PageViewModel {
    func getScreenShootImage() -> UIImage? {
        if let screenshootModel = model.fields.last as? ScreenshotModel {
            return screenshootModel.image
        }
        return nil
    }
}
