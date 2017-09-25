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
    let mode: RatingMode
    override init(json: JSON, pageModel: PageModel) {
        mode = json["mode"].stringValue == "star" ? .star : .emoticon

        if mode == .emoticon && json["points"].exists() {
            self.points = json["points"].intValue
        }
        super.init(json: json, pageModel: pageModel)
    }
}
