//
//  MoodFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class MoodFieldModel: IntFieldModel {
    let points: Int
    required init(json: JSON, pageModel: PageModel) {
        points = json["points"].intValue
        super.init(json: json, pageModel: pageModel)
    }

}
