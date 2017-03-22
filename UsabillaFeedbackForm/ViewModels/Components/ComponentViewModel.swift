//
//  ComponentViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseComponentViewModel<T, V: ComponentModel>: ComponentViewModel {
    var model: V
    var theme: UsabillaThemeConfigurator {
        return model.themeConfig
    }

    var value: T?

    init(model: V) {
        self.model = model
    }
}
