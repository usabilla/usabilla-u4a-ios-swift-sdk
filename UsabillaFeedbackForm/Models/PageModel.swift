//
//  PageModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class PageModel {
    
    var fields: [BaseFieldModel]!
    var fieldValuesCollection: [String: [String]] = [:] {
        didSet {
            SwiftEventBus.postToMainThread("pageUpdatedValues", sender: self)
        }
    }
    
    let pageNumber: Int?
    let pageName: String?
    var type: String?
    var isLastPage: Bool?
    
    var jumpRuleList: [JumpRule]?
    var defaultJumpTo: String?
    var errorMessage: String?
    
    
    init(pageNumber: Int, pageName: String) {
        self.pageNumber = pageNumber
        self.pageName = pageName
        errorMessage = nil
        fields = nil
        type = nil
        isLastPage = nil
        jumpRuleList = nil
        defaultJumpTo = nil
    }
    
    deinit {
        print("called page model \(pageName) , \(pageNumber) deinit")
        print("containing \(fields.count) fields")
    }
}
