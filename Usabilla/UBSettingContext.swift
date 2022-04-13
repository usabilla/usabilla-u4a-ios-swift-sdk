//
//  UBSettingContext.swift
//  Usabilla
//
//  Created by Hitesh Jain on 02/12/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit

// Move it to the corect path
struct UBSettingContext: UBSettingProtocol {
    let platform: String
    let sdkversion: String
    let appId: String
    init(appId: String = "") {
        self.platform = "ios"
        self.appId = appId
        sdkversion = Bundle.sdkVersion
       }
}
