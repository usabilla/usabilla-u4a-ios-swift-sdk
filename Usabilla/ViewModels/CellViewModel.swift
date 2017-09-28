//
//  CellViewModel.swift
//  Usabilla
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

    private(set) var isViewCurrentlyVisible = true

    init(model: BaseFieldModel, theme: UsabillaTheme) {
        self.model = model
        self.title = model.fieldTitle
        self.theme = theme
        // swiftlint:disable:next force_unwrapping
        self.copy = model.pageModel.copy!
        self.required = model.required
        componentViewModel = ComponentViewModelFactory.component(field: model, theme: theme)
    }

    func updateVisibility() {
        let newIsViewCurrentlyVisible = model.shouldAppear()
        if newIsViewCurrentlyVisible != isViewCurrentlyVisible {
            isViewCurrentlyVisible = newIsViewCurrentlyVisible
            if newIsViewCurrentlyVisible == false {
                PLog("reset")
                model.reset()
            }
        }
    }

    var shouldAppear: Bool {
        return model.shouldAppear()
    }

    var isValid: Bool {
        if isViewCurrentlyVisible {
            return model.isValid()
        }
        return true
    }
    func updateErrorLabel() {
        showErrorLabel = required && !model.isValid()
    }
}
