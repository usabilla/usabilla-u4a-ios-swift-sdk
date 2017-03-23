//
//  CopyModel.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 04/11/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class CopyModel {
    var navigationNext: String?
    var cancelButton: String?
    var screenshotTitle: String?
    var moreFeedback: String?
    var appStore: String?
    var appTitle: String?
    var navigationSubmit: String?
    var errorMessage: String?
    var requiredFieldError: String?
    var screenshotPlaceholder: String?
    var introContinueButton: String?
    var introCancelButton: String?

    init() {
        cancelButton = LocalisationHandler.getLocalisedStringForKey("usa_form_close_button")
        navigationNext = LocalisationHandler.getLocalisedStringForKey("usa_form_continue_button")
        appStore = LocalisationHandler.getLocalisedStringForKey("usa_invite_rate_app_store")
        moreFeedback = LocalisationHandler.getLocalisedStringForKey("usa_more_feedback")
        requiredFieldError = LocalisationHandler.getLocalisedStringForKey("usa_form_required_field_error")
        screenshotPlaceholder = LocalisationHandler.getLocalisedStringForKey("usa_screnshot_placeholder")
    }

    init(json: JSON) {
        let data = json["data"]
        appTitle = data["appTitle"].string
        navigationSubmit = data["appSubmit"].string
        errorMessage = data["errorMessage"].string

        let localization = json["localization"]

        if let appStore = localization["appStore"].string {
            self.appStore = appStore
        }
        if let moreFeedback = localization["moreFeedback"].string {
            self.moreFeedback = moreFeedback
        }
        if let screenshotTitle = localization["screenshotTitle"].string {
            self.screenshotTitle = screenshotTitle
        }
        if let cancelButton = localization["cancelButton"].string {
            self.cancelButton = cancelButton
        }
        if let navigationNext = localization["navigationNext"].string {
            self.navigationNext = navigationNext
        }
        if let introCancel = localization["introCancelButton"].string {
            self.introCancelButton = introCancel
        }
        if let introContinue = localization["introContinueButton"].string {
            self.introContinueButton = introContinue
        }
    }

}
