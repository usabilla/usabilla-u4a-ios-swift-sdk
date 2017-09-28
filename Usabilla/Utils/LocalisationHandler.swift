//
//  LocalisationHandler.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 04/07/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class LocalisationHandler {

    static func getLocalisedStringForKey(_ key: String) -> String {
        if UsabillaInternal.defaultLocalisationFile {
            let bundle = Bundle(identifier: "com.usabilla.Usabilla")!
            return NSLocalizedString(key, tableName: Usabilla.localizedStringFile, bundle: bundle, comment: "")
        } else {
            return NSLocalizedString(key, tableName: Usabilla.localizedStringFile, comment: "")
        }

    }

}
