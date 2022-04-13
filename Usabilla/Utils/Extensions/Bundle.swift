//
//  Bundle.swift
//  Usabilla
//
//  Created by Hitesh Jain on 12/04/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

extension Bundle {
    static var sdkBundle: Bundle? {
        guard let SDKBundle = Bundle(identifier: "com.usabilla.Usabilla") else {
            return nil
        }
        return SDKBundle
    }

    static var sdkVersion: String {
        guard let str = sdkBundle?.object(forInfoDictionaryKey: "USABILLA_VERSION") as? String else {
            PLog("Unable to read SDK version from Usabilla's Info.plist file")
            return "0.0.0"
        }
        return str
    }

    static var sdkBuild: String {
        guard let str = sdkBundle?.object(forInfoDictionaryKey: "USABILLA_BUILD") as? String else {
            PLog("Unable to read SDK build from Usabilla's Info.plist file")
            return "0.0.0"
        }
        return str
    }

     static var appName: String {
         guard let str = main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
             PLog("❌ impossible to get host app name")
             return ""
         }
         return str
    }

     static var appVersion: String {
        guard let str = main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            PLog("❌ impossible to get host app version")
            return ""
        }
        return str
    }

     static var appBuild: String {
         guard let str = main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
             PLog("❌ impossible to get host app build")
             return ""
         }
         return str
    }

     static var appIdentifier: String {
         guard let str = main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String else {
             PLog("❌ impossible to get host app identifier")
             return ""
         }
         return str
    }

    static var xcodeVersion: String {
        guard let str = main.object(forInfoDictionaryKey: "DTXcode") as? String else {
            PLog("❌ impossible to get host xcode version")
            return ""
        }
        return str
   }
}
