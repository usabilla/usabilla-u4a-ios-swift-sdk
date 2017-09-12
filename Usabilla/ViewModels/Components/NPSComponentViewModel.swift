//
//  NPSComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 12/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class NPSComponentViewModel: BaseIntComponentViewModel<NPSFieldModel> {
    var lowLabel: String? {
        return model.low
    }
    var highLabel: String? {
        return model.high
    }
}
