//
//  ParagraphFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class ParagraphFieldModel: StringFieldModel {

    let isHTML: Bool
    let immutableParagraphValue: String?

    override init(json: JSON, pageModel: PageModel) {
        isHTML = json["html"].boolValue
        immutableParagraphValue = json["text"].string
        super.init(json: json, pageModel: pageModel)
        fieldValue = json["text"].string
    }

    override func convertToJSON() -> Any? {
        return nil
    }
}
