//
//  DeviceInfo.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 22/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class DeviceInfo {
    class func getMaxFormWidth() -> CGFloat {
        if DeviceInfo.isIPad() {
            return 540
        }
        return UIScreen.main.bounds.size.width
    }

    class func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    class func isIphoneX() -> Bool {
        let deviceType = UIDevice.current.modelName
        return deviceType.range(of: "iPhone10,3") != nil || deviceType.range(of: "iPhone10,6") != nil || UIScreen.main.nativeBounds.height == 2436
    }

    class func isJailbroken() -> Bool {
        let str = "Jailbreak test string"
        do {
            try str.write(toFile: "/private/test_jail.txt", atomically: true, encoding: String.Encoding.utf8)
            try FileManager().removeItem(atPath: "/private/test_jail.txt")
            return true
        } catch _ {
            return false
        }
    }

    class DiskStatus {
        class var totalDiskSpaceInBytes: Int64 {
            return (DeviceInfo.DiskStatus.systemAttributes?[FileAttributeKey.systemSize] as? NSNumber)?.int64Value ?? 0
        }

        class var freeDiskSpaceInBytes: Int64 {
            return (DeviceInfo.DiskStatus.systemAttributes?[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value ?? 0
        }

        class var systemAttributes: [FileAttributeKey: Any]? {
            return try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
        }
    }
}
