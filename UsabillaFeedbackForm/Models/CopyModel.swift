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

    convenience init(json: JSON) {
        self.init()

        let data = json["data"]
        appTitle = data["appTitle"].string
        navigationSubmit = data["appSubmit"].string
        errorMessage = data["errorMessage"].string

        let loc = json["localization"]
        self.appStore = loc["appStore"].string ?? self.appStore
        self.moreFeedback = loc["moreFeedback"].string ?? self.moreFeedback
        self.screenshotTitle = loc["screenshotTitle"].string ?? self.screenshotTitle
        self.cancelButton = loc["cancelButton"].string ?? self.cancelButton
        self.navigationNext = loc["navigationNext"].string ?? self.navigationNext
        self.introCancelButton = loc["introCancelButton"].string ?? self.introCancelButton
        self.introContinueButton = loc["introContinueButton"].string ?? self.introContinueButton

        let banner = json["form"]["pages"].first {
            $0.1["type"].stringValue == "banner"
        }
        let continueField = banner?.1["fields"].first {
            $0.1["type"].stringValue == "continue"
        }?.1

        if let continuetitle = continueField?["title"].string {
            self.introContinueButton = continuetitle
        }

        if let cancelTitle = continueField?["cancel"].string {
            self.introCancelButton = cancelTitle
        }
    }
}
