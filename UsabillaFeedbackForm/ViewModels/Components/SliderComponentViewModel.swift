//
//  SliderComponentViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class SliderComponentViewModel: BaseIntComponentViewModel<RatingFieldModel> {
    var scale: Int? {
        return model.scale
    }
    var lowLabel: String? {
        return model.low
    }
    var highLabel: String? {
        return model.high
    }
    var isNPS: Bool {
        return model.isNPS
    }
}
