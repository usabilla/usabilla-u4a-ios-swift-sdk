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
    let theme: UsabillaTheme
    let copy: CopyModel
    let required: Bool
    var componentViewModel: ComponentViewModel?
    var showErrorLabel: Bool = false

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
    init(model: BaseFieldModel, theme: UsabillaTheme) {
        self.model = model
        self.title = model.fieldTitle
        self.theme = theme
        self.copy = model.pageModel.copy!
        self.required = model.required
        componentViewModel = ComponentViewModelFactory.component(field: model, theme: theme)
    }

    var shouldAppear: Bool {
        return model.shouldAppear()
    }

    func updateErrorLabel() {
        showErrorLabel = required && !model.isValid()
    }
}
