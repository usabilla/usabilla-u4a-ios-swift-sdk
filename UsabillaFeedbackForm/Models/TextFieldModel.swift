//
//  TextFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class TextFieldModel: StringFieldModel, EditableStringComponentModel, Exportable {

    let placeHolder: String?
    let defaultValue: String?

    var exportableValue: Any? {
        return fieldValue
    }

    override init(json: JSON, pageModel: PageModel) {
        placeHolder = json["placeholder"].string
        defaultValue = json["defaultValue"].string
        super.init(json: json, pageModel: pageModel)
    }
}
