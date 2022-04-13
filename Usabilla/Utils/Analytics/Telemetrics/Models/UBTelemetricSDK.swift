//
//  UBMobile.swift
//  Usabilla
//
//  Created by Anders Liebl on 11/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit
class UBTelemetricSDK: UBTelemetricProtocol {
    let system: String
    let osV: String
    let sdkV: String
    let appV: String
    let appN: String
    let device: String
    let totMem: Double
    let totSp: Double

    init() {
        let uiDevice = UIDevice.current
        system = "ios"

        osV = uiDevice.systemVersion
        sdkV = Bundle.sdkVersion
        appV = Bundle.appVersion
        appN = Bundle.appName
        device = uiDevice.modelName
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

        totMem = Double(ProcessInfo.processInfo.physicalMemory / 1024)
        totSp = Double(DeviceInfo.DiskStatus.totalDiskSpaceInBytes / 1024)
    }
}
