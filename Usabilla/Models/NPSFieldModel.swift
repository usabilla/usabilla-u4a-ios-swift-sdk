//
//  NPSFieldModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 12/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class NPSFieldModel: IntFieldModel {
    let low, high: String?

    override init(json: JSON, pageModel: PageModel) {
        low = json["low"].string
        high = json["high"].string
        super.init(json: json, pageModel: pageModel)
    }
}
