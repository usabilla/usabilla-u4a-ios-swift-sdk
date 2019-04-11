//
//  TextFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class TextFieldModel: StringFieldModel, EditableStringComponentModel, Exportable, MaskProtocol {

    var masks: MaskModel?
    let placeHolder: String?
    let defaultValue: String?

    var exportableValue: Any? {
        return masks?.toMaskText(fieldValue) ?? fieldValue
    }

    override init(json: JSON) {
        placeHolder = json["placeholder"].string
        defaultValue = json["defaultValue"].string
        super.init(json: json)
    }
}
