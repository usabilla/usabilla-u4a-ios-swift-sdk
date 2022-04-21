//
//  AppMetaData.swift
//  Usabilla
//
//  Created by Hitesh Jain on 11/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation
import UIKit

struct AppMetaData {
    var metadata: [String: Any] = [:]
    init() {
        let uiDevice = UIDevice.current
        let screenBounds = UIScreen.main.bounds

        uiDevice.isBatteryMonitoringEnabled = true
        metadata["app_version"] = Bundle.appVersion
        metadata["battery"] = abs(uiDevice.batteryLevel)
        metadata["device"] = uiDevice.modelName
        metadata["language"] = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode)
        metadata["orientation"] = UIDeviceOrientationIsLandscape(uiDevice.orientation) ? "Landscape" : "Portrait"
        metadata["os_version"] = uiDevice.systemVersion
        metadata["screen"] = "\(Int(screenBounds.width)) x \(Int(screenBounds.height))"
        metadata["sdk_version"] = Bundle.sdkVersion
        metadata["system"] = "ios"
        metadata["timestamp"] = Date().toRFC3339Format()
        metadata["app_name"] = Bundle.appName
    }
}
