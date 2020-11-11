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
            return getDefaultLocalisedStringForKey(key, localeFile: UsabillaInternal.localizedStringFile)
        } else {
            var value = NSLocalizedString(key, tableName: UsabillaInternal.localizedStringFile, comment: "")
            if value == key {
                value = getDefaultLocalisedStringForKey(key, localeFile: UsabillaInternal.defaultLocalizedStringFile)
            }
            return value
        }
    }

    fileprivate static func getDefaultLocalisedStringForKey(_ key: String, localeFile: String) -> String {
        // swiftlint:disable:next force_unwrapping
        let bundle = Bundle(identifier: "com.usabilla.Usabilla")!
        let value = NSLocalizedString(key, tableName: localeFile, bundle: bundle, comment: "")
        return value
    }
}
