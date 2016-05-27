//
//  CommentFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class CommentFieldModel: StringFieldModel {
    
    let text: String?
    
    required init(json: JSON, pageModel: PageModel) {
        text = json["text"].string
        super.init(json: json, pageModel: pageModel)
    }

}
