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

    var formRating: Int = 0

    var theme: UsabillaThemeConfigurator {
        return model.themeConfig
    }

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

    init(model: UBEndPageModel) {
        self.model = model

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
