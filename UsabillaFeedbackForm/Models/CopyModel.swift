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

}
