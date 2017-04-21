//
//  MoodFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class MoodFieldModel: IntFieldModel {
    var points: Int = 5
    override init(json: JSON, pageModel: PageModel) {
        if json["points"].exists() {
            points =  json["points"].intValue
        }
        super.init(json: json, pageModel: pageModel)
    }
}
