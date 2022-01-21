//
//  UBInfo.swift
//  Usabilla
//
//  Created by Hitesh Jain on 21/01/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

class UBInfo {

    class func getBundle() -> Bundle? {
        guard let bundle = Bundle(identifier: "com.usabilla.Usabilla") else {
            return nil
        }
        return bundle
    }

    static var sdkVersion: String {
        guard let SDKVersion = getBundle()?.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        else { return "0.0.0" }
        return SDKVersion
    }
}
