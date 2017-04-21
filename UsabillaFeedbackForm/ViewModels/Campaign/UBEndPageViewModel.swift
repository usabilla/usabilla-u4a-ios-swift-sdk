//
//  UBEndPageViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 03/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBEndPageViewModel {

    private var model: UBEndPageModel
    private(set) var theme: UsabillaTheme

    var formRating: Int = 0

    var canRedirectToAppStore: Bool {
        return model.redirectToAppStore && formRating > 3 && UsabillaFeedbackForm.appStoreId != nil
    }

    var canGiveMoreFeedback: Bool {
        return model.giveMoreFeedback
    }

    var appStoreRedirectText: String? {
        return model.copy?.appStore
    }

    var moreFeedbackText: String? {
        return model.copy?.moreFeedback
    }

    var thankyouText: String?
    var headerText: String?

    init(model: UBEndPageModel, theme: UsabillaTheme) {
        self.model = model
        self.theme = theme
        if model.fields.count > 0 {
            if let header: HeaderFieldModel = model.fields[0] as? HeaderFieldModel {
                headerText = header.fieldValue
            }
        }

        if model.fields.count > 1 {
            if let thank: StringFieldModel = model.fields[1] as? StringFieldModel {
                thankyouText = thank.fieldValue
            }
        }
    }
}
