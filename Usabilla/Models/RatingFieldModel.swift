//
//  RatingFieldModel.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 06/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class RatingFieldModel: IntFieldModel {

    let textPositioning, low, high: String?
    let scale: Int?

    override init(json: JSON, pageModel: PageModel) {
        textPositioning = json["textPositioning"].string
        low = json["low"].string
        high = json["high"].string
        scale = json["scale"].int
        super.init(json: json, pageModel: pageModel)
    }
}
