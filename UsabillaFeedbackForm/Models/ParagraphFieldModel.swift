//
//  ParagraphFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParagraphFieldModel: StringFieldModel {
    
    let html: Bool?
    
    required init(json: JSON, pageModel: PageModel) {
        html = json["html"].bool
        super.init(json: json, pageModel: pageModel)
        fieldValue = json["text"].stringValue
    }
    
}
