//
//  ParagraphFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class ParagraphFieldModel: StringFieldModel {

    let html: Bool?
    let immutableParagraphValue: String?

    required init(json: JSON, pageModel: PageModel) {
        html = json["html"].bool
        immutableParagraphValue = json["text"].string
        super.init(json: json, pageModel: pageModel)
        fieldValue = json["text"].string
    }

    override func convertToJSON() -> Any? {
        return nil
    }
}
