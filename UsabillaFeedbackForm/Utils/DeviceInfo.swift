//
//  DeviceInfo.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 22/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class DeviceInfo {


    class func totalRamOfDevice () -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }


    class func deviceRemainingFreeSpaceInBytes() -> Int? {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                          task_flavor_t(MACH_TASK_BASIC_INFO),
                          $0,
                          &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            print("Memory in use (in bytes): \(info.resident_size)")
            return Int(info.resident_size)
        }
        else {
            print("Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
        }
        return nil
    }



    class func isJailbroken() -> Bool {
        #if !TARGET_IPHONE_SIMULATOR

            let str = "Jailbreak test string"
            do {
                try str.write(toFile: "/private/test_jail.txt", atomically: true, encoding: String.Encoding.utf8 )
                try FileManager().removeItem(atPath: "/private/test_jail.txt")
                return true
            } catch _ {
                return false
            }
        #endif
    }




    class DiskStatus {

        //MARK: Formatter MB only
        class func MBFormatter(_ bytes: Int64) -> String {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = ByteCountFormatter.Units.useMB
            formatter.countStyle = ByteCountFormatter.CountStyle.decimal
            formatter.includesUnit = false
            return formatter.string(fromByteCount: bytes) as String
        }


        //MARK: Get String Value
        class var totalDiskSpace: String {
            get {
                return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
        }

        class var freeDiskSpace: String {
            get {
                return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
        }

        class var usedDiskSpace: String {
            get {
                return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
        }


        //MARK: Get raw value
        class var totalDiskSpaceInBytes: Int64 {
            get {
                do {
                    let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                    let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                    return space!
                } catch {
                    return 0
                }
            }
        }

        class var freeDiskSpaceInBytes: Int64 {
            get {
                do {
                    let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                    let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                    return freeSpace!
                } catch {
                    return 0
                }
            }
        }

        class var usedDiskSpaceInBytes: Int64 {
            get {
                let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
                return usedSpace
            }
        }

    }


}
