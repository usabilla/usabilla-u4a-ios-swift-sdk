//
//  UIApplication.swift
//  Usabilla
//
//  Created by Anders Liebl on 08/02/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import Foundation
extension UIApplication {
    static var hasCameraPermissioninPList: Bool {
        return Bundle.main.object(forInfoDictionaryKey: "NSCameraUsageDescription") != nil
    }

    static var hasLibraryPermissioninPList: Bool {
        return Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription") != nil
    }

}
