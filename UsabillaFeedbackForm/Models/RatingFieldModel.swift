//
//  RatingFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import SwiftyJSON


class RatingFieldModel: IntFieldModel {
    
    let textPositioning, low, high: String?
    let scale: Int?
    let isNPS: Bool
    
    
    required init(json: JSON, pageModel: PageModel) {
        textPositioning = json["textPositioning"].string
        low = json["low"].string
        high = json["high"].string
        scale = json["scale"].int
        self.isNPS = false
        super.init(json: json, pageModel: pageModel)
    }
    
    init(json: JSON, pageModel: PageModel, isNPS: Bool = false) {
        textPositioning = json["textPositioning"].string
        low = json["low"].string
        high = json["high"].string
        scale = json["scale"].int
        self.isNPS = isNPS
        super.init(json: json, pageModel: pageModel)
        self.type = "rating"
    }
}
