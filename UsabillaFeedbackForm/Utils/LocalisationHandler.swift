//
//  LocalisationHandler.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 04/07/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class LocalisationHandler {

    static func getLocalisedStringForKey(key: String) -> String {
        if UsabillaFeedbackForm.defaultLocalisationFile {
            let bundle = NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")!
            return NSLocalizedString(key, tableName: UsabillaFeedbackForm.localizedStringFile, bundle: bundle, comment: "")
        } else {
            return NSLocalizedString(key, tableName: UsabillaFeedbackForm.localizedStringFile, comment: "")
        }

    }

}
