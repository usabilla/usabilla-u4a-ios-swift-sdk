//
//  ChoiceFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation



class ChoiceFieldModel: OptionsFieldModel {
    let defaultValue: String?
    let emptyValue: String?
    var expanded: Bool = false

    override init(json: JSON, pageModel: PageModel) {
        defaultValue = json["defaultValue"].string
        emptyValue = json["empty"].string
        super.init(json: json, pageModel: pageModel)
    }
}
