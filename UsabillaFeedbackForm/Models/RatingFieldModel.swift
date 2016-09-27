//
//  RatingFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 06/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


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
//    deinit {
//        print("rating field model")
//    }
    
}
