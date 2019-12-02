//
//  UBMobile.swift
//  Usabilla
//
//  Created by Anders Liebl on 11/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

class UBTelemetricSDK: Codable {
    var system: String
    var osVersionMajor: String
    let osVersionMinor: String
    let osVersionPatch: String
    let sdkVersionMajor: String
    let sdkVersionMinor: String
    let sdkVersionPatch: String
    var bridge: String?
    var appVersion: String
    let appName: String
    let device: String
    var reacability: String?
    let orientation: String
    let freeMemory: Double
    let totalMemory: Double
    var freeSpace: Double
    var totalSpace: Double
    let rooted: Bool
    let screenSize: String

    // swiftlint:disable:next function_body_length
    init() {
        let reach = Reachability.init()
        let uiDevice = UIDevice.current
        system = "ios"

        let iosVersion = uiDevice.systemVersion.components(separatedBy: ".")
        if iosVersion.count > 0 {
            osVersionMajor = iosVersion[0]
        } else {
            osVersionMajor = "-"
        }
        if iosVersion.count > 1 {
            osVersionMinor = iosVersion[1]
        } else {
            osVersionMinor = "-"
        }
        if iosVersion.count > 2 {
            osVersionPatch = iosVersion[2]
        } else {
            osVersionPatch = "-"
        }

        if let SDKVersion = Bundle(identifier: "com.usabilla.Usabilla")?.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            let SDKVersions = SDKVersion.components(separatedBy: ".")
            if  SDKVersions.count > 0 {
                sdkVersionMajor = SDKVersions[0]
            } else {
                sdkVersionMajor = "-"
            }
            if  SDKVersions.count > 1 {
                sdkVersionMinor = SDKVersions[1]
            } else {
                sdkVersionMinor = "-"
            }
            if  SDKVersions.count > 2 {
                sdkVersionPatch = SDKVersions[2]
            } else {
                sdkVersionPatch = "-"
            }
        } else {
            sdkVersionMajor = "-"
            sdkVersionMinor = "-"
            sdkVersionPatch = "-"
        }

        appVersion = ""
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            self.appVersion = version
        } else {
            self.appVersion = "unknown"
        }

        if let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            self.appName = appName
        } else {
            self.appName = "unknown"
        }

        device = uiDevice.modelName
        reacability = reach?.currentReachabilityString
        orientation = UIDeviceOrientationIsLandscape(uiDevice.orientation) ? "Landscape" : "Portrait"
        var pagesize: vm_size_t = 0

        let hostport: mach_port_t = mach_host_self()
        var hostsize: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        host_page_size(hostport, &pagesize)

        var vmstat: vm_statistics = vm_statistics_data_t()
        withUnsafeMutablePointer(to: &vmstat) { (vmStatPointer) -> Void in
            vmStatPointer.withMemoryRebound(to: integer_t.self, capacity: Int(hostsize)) {
                if host_statistics(hostport, HOST_VM_INFO, $0, &hostsize) != KERN_SUCCESS {
                    NSLog("Error: Failed to fetch vm statistics")
                }
            }
        }

        freeMemory = Double(vmstat.free_count) * Double(pagesize)
        totalMemory = Double(ProcessInfo.processInfo.physicalMemory / 1024)

        freeSpace = Double(DeviceInfo.DiskStatus.freeDiskSpaceInBytes / 1024)
        totalSpace = Double(DeviceInfo.DiskStatus.totalDiskSpaceInBytes / 1024)

        rooted = DeviceInfo.isJailbroken()
        let screenBounds = UIScreen.main.bounds
        screenSize = "\(Int(screenBounds.width)) x \(Int(screenBounds.height))"
    }
}
