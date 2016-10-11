//
//  NPSFieldModel.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class NPSFieldModel: IntFieldModel {

    let mode, low, high: String?
    let colorLegend: Bool?


    required init(json: JSON, pageModel: PageModel) {
        mode = json["mode"].string
        low = json["low"].string
        high = json["high"].string
        colorLegend = json["colorLegend"].bool
        super.init(json: json, pageModel: pageModel)
    }

//    deinit {
//        print("nps field model")
//    }

}
