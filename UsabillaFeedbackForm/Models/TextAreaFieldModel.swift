//
//  TextAreaFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class TextAreaFieldModel: StringFieldModel {

    let placeHolder: String?

    override init(json: JSON, pageModel: PageModel) {
        placeHolder = json["placeholder"].string
        super.init(json: json, pageModel: pageModel)
    }

}
