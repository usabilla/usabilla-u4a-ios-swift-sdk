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
            return 640
        }
        return UIScreen.main.bounds.size.width
    }
    class func getMaxFormHeight() -> CGFloat {
        if DeviceInfo.isIPad() {
            return 1000
        }
        return UIScreen.main.bounds.size.height
    }

    class func getLeftCardBorder() -> CGFloat {
        if DeviceInfo.isIPad() {
            return 23
        }
        return 16
    }

    class func getRightCardBorder() -> CGFloat {
        if DeviceInfo.isIPad() {
            return 23
        }
        return 16
    }

    class func getTopCardBorder() -> CGFloat {
        if DeviceInfo.isIPad() {
            return 23
        }
        return 16
    }

    class func getBottomCardBorder() -> CGFloat {
        if DeviceInfo.isIPad() {
            return 23
        }
        return 16
    }

    class func preferedFormSize(_ screenSize: CGSize = UIScreen.main.bounds.size) -> CGSize {
        let formWidth: CGFloat = DeviceInfo.getMaxFormWidth() // default width
        let formHeight: CGFloat = DeviceInfo.getMaxFormHeight() // default maks height
        //let screen = UIScreen.main.bounds
        let margin: CGFloat = 50 // default minimum margin
        let height = screenSize.height - 2 * margin
        return CGSize(width: formWidth, height: (height > formHeight ? formHeight : height))
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
