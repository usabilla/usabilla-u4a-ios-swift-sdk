//
//  PageViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol UBPageViewModel {
    init(page: PageModel, theme: UsabillaTheme)
}

class PageViewModel: UBPageViewModel {

    var cellViewModels: [CellViewModel] = []
    let model: PageModel
    var dynamicFields: [Int] = []
    var shouldAddMarginWhenKeyboardIsShown: Bool = true
    let theme: UsabillaTheme
    let copy: CopyModel
    let errorMessage: String?
    var name: String? {
        return model.pageName
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var isCorrectlyFilled: Bool {
        return cellViewModels.filter { !$0.isValid }.count == 0
    }
    var shouldShowRequiredLabel: Bool {
        return cellViewModels.filter { $0.required }.count > 0
    }

    required init(page: PageModel, theme: UsabillaTheme) {
        self.model = page
        self.theme = theme
        // swiftlint:disable:next force_unwrapping
        self.copy = page.copy!
        self.errorMessage = page.errorMessage
        for (index, fieldModel) in page.fields.enumerated() {
            cellViewModels.append(CellViewModel(model: fieldModel, theme: theme))
            if fieldModel.rule != nil {
                dynamicFields.append(index)
            }
        }
    }

    func viewModelForCellAt(index: Int) -> CellViewModel? {
        guard index >= 0 && index < cellViewModels.count else {
            return nil
        }
        return cellViewModels[index]
    }

    /**
     Returns the index for the first field of the page which is invalid
     */
    func indexOfInvalidField() -> Int? {
        for (index, field) in model.fields.enumerated() {
            if !field.isValid() {
                return index
            }
        }
        return nil
    }

    /**
     Returns the name/id of the next page name based on the jump rules
     */
    func nextPageName() -> String? {
        if model.jumpRuleList != nil && model.jumpRuleList!.count > 0 {
            for rule in model.jumpRuleList! {
                if rule.isSatisfied() {
                    return rule.jumpTo
                }
            }
        }
        return model.defaultJumpTo
    }

    func verifyFields() {
        cellViewModels.filter {
            $0.required == true
        }.forEach {
            $0.updateErrorLabel()
        }
    }
}
