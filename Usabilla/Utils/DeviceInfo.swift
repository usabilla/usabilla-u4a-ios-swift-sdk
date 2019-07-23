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
        if UsabillaInternal.supportedOrientations == .all {
            return UIScreen.main.bounds.size.width
        }
        if UsabillaInternal.supportedOrientations == .landscape ||
            UsabillaInternal.supportedOrientations == .landscapeLeft ||
            UsabillaInternal.supportedOrientations == .landscapeRight {
            return max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
        }
        return min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
    }

    class func getBounds() -> CGRect {
        if UsabillaInternal.supportedOrientations == .landscape ||
            UsabillaInternal.supportedOrientations == .landscapeLeft ||
            UsabillaInternal.supportedOrientations == .landscapeRight {
            let width = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
            let height = min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            return rect
        }
        return UIScreen.main.bounds
    }

    class func getViewCenter() -> CGPoint {
       //  return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        if UsabillaInternal.supportedOrientations == .landscape ||
            UsabillaInternal.supportedOrientations == .landscapeLeft ||
            UsabillaInternal.supportedOrientations == .landscapeRight {
            let midx = max (UIScreen.main.bounds.midY, UIScreen.main.bounds.midX)
            let midy = min (UIScreen.main.bounds.midY, UIScreen.main.bounds.midX)
            return CGPoint(x: midx, y: midy)
        }
        return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    }

    class func getMaxFormHeight() -> CGFloat {
        if DeviceInfo.isIPad() {
            return 968
        }
        if UsabillaInternal.supportedOrientations == .landscape ||
            UsabillaInternal.supportedOrientations == .landscapeLeft ||
            UsabillaInternal.supportedOrientations == .landscapeRight {
            return UIScreen.main.bounds.size.width
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
    class func getBottomSafeInsets() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets.bottom ?? 0.0
        }
        return 0.0
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
    class func requiredOrientationAvailable() -> Bool {
        // if this is iPhone only, then we require portrait
        if isIPad() { return true }
        if let test =  Bundle.main.infoDictionary?["UISupportedInterfaceOrientations"] as? [String] {
            for orientation in test {
                if orientation == "UIInterfaceOrientationPortrait"  ||
                   orientation == "UIInterfaceOrientationPortraitUpsideDown" {
                    return true
                }
            }
        }
        return false
    }
}
