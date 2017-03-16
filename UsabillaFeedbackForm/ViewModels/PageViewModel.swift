//
//  PageViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class PageViewModel {

    private var cellViewModels: [CellViewModel]
    private let model: PageModel

    let theme: UsabillaThemeConfigurator
    let copy: CopyModel
    let errorMessage: String?

    var numberOfCells: Int {
        return cellViewModels.count
    }

    init(page: PageModel) {
        self.cellViewModels = []
        self.model = page
        self.theme = page.themeConfig
        self.copy = page.copy!
        self.errorMessage = page.errorMessage

        for fieldModel in page.fields {
            cellViewModels.append(CellViewModel(model: fieldModel))
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

}
