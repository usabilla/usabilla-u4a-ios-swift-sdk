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

    static var topMargin: CGFloat {
        get {
            if DeviceInfo.hasTopNotch {
                return 50
            }
            if DeviceInfo.isIPad() {
                return 23
            }
            return 16
        }
        set {}
    }

    static var bottomMargin: CGFloat {
        get {
            if DeviceInfo.isIPad() {
                return 23
            }
            return 16
        }
        set {}
    }

    static var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
        }
        return false
    }

    static var offsetRightNotch: CGFloat {
        if UsabillaInternal.supportedOrientations == .landscapeLeft {
            return 64
        }
        if #available(iOS 11.0, *) {
            let value: CGFloat = UIApplication.shared.delegate?.window??.safeAreaInsets.right ?? 0
            return value
        }
        return 0
    }

    class func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
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
