//
//  HeaderFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class HeaderFieldModel: StringFieldModel {

    override init(json: JSON) {
        super.init(json: json)
        fieldValue = json["text"].string
    }
}
