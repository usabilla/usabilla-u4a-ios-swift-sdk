//
//  CellViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CellViewModel {

    let model: BaseFieldModel
    let title: String
    let theme: UsabillaThemeConfigurator
    let copy: CopyModel
    let required: Bool

    var componentViewModel: ComponentViewModel?

    var isValid: Bool {
        return model.isModelValid
    }

    var isViewCurrentlyVisible: Bool {
        get {
            return model.isViewCurrentlyVisible
        }

        set {
            if model.isViewCurrentlyVisible != newValue {
                model.isViewCurrentlyVisible = newValue
            }
        }
    }
    init(model: BaseFieldModel) {
        self.model = model
        self.title = model.fieldTitle
        self.theme = model.themeConfig
        self.copy = model.pageModel.copy!
        self.required = model.required
        componentViewModel = ComponentViewModelFactory.component(field: model)
    }

    var shouldAppear: Bool {
        return model.shouldAppear()
    }
}
