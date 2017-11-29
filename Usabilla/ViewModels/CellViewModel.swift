//
//  CellViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CellViewModel {

    weak var delegate: CellViewModelDelegate?
    let model: BaseFieldModel
    let title: String
    let theme: UsabillaTheme
    let copy: CopyModel
    let required: Bool
    var componentViewModel: ComponentViewModel?
    var showErrorLabel: Bool = false
    var shouldAppear: Bool {
        return model.shouldAppear()
    }
    var isValid: Bool {
        if isViewCurrentlyVisible {
            return model.isValid()
        }
        return true
    }
    private(set) var isViewCurrentlyVisible = true

    init(model: BaseFieldModel, theme: UsabillaTheme, copy: CopyModel) {
        self.model = model
        self.title = model.fieldTitle
        self.theme = theme
        self.copy = copy
        self.required = model.required
        componentViewModel = ComponentViewModelFactory.component(field: model, theme: theme, copy: copy)
        componentViewModel?.delegate = self
    }

    func updateVisibility() {
        let newIsViewCurrentlyVisible = model.shouldAppear()
        if newIsViewCurrentlyVisible != isViewCurrentlyVisible {
            isViewCurrentlyVisible = newIsViewCurrentlyVisible
            if newIsViewCurrentlyVisible == false {
                PLog("reset")
                componentViewModel?.reset()
            }
        }
    }

    func updateErrorLabel() {
        showErrorLabel = required && !model.isValid()
    }
}

extension CellViewModel: ComponentViewModelDelegate {
    func valueDidChange() {
        delegate?.valueDidChange(model: model)
    }
}
