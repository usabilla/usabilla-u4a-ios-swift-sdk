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
        return NSProcessInfo.processInfo().physicalMemory
    }
    
    
    class func deviceRemainingFreeSpaceInBytes() -> Int? {
        //Wont fucking fix
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(sizeofValue(info))/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(&info) {
            
            task_info(mach_task_self_,
                      task_flavor_t(MACH_TASK_BASIC_INFO),
                      task_info_t($0),
                      &count)
            
        }
        
        if kerr == KERN_SUCCESS {
            Swift.debugPrint("Memory in use (in bytes): \(info.resident_size)")
            return Int(info.resident_size)
        } else {
            Swift.debugPrint("Error with task_info(): " +
                (String.fromCString(mach_error_string(kerr)) ?? "unknown error"))
        }
        
//        let MACH_TASK_BASIC_INFO_COUNT = (sizeof(mach_task_basic_info_data_t) / sizeof(natural_t))
//        
//        // prepare parameters
//        let name   = mach_task_self_
//        let flavor = task_flavor_t(MACH_TASK_BASIC_INFO)
//        var size   = mach_msg_type_number_t(MACH_TASK_BASIC_INFO_COUNT)
//        
//        // allocate pointer to mach_task_basic_info
//        var infoPointer = UnsafeMutablePointer<mach_task_basic_info>.alloc(1)
//        
//        // call task_info - note extra UnsafeMutablePointer(...) call
//        let kerr = task_info(name, flavor, UnsafeMutablePointer(infoPointer), &size)
//        
//        // get mach_task_basic_info struct out of pointer
//        let info = infoPointer.move()
//        
//        // deallocate pointer
//        infoPointer.dealloc(1)
//        
//        // check return value for success / failure
//        if kerr == KERN_SUCCESS {
//            print("Memory in use (in MB): \(info.resident_size/1000000)")
//            return Int(info.resident_size)
//        } else {
//            //let errorString = String(CString: mach_error_string(kerr), encoding: NSASCIIStringEncoding)
//           // println(errorString ?? "Error: couldn't parse error string")
//        }
        return nil
    }
    
  
    
    class func isJailbroken() -> Bool {
        #if !TARGET_IPHONE_SIMULATOR
            
            let str = "Jailbreak test string"
            do {
                try str.writeToFile("/private/test_jail.txt", atomically: true, encoding: NSUTF8StringEncoding )
                try NSFileManager().removeItemAtPath("/private/test_jail.txt")
                return true
            } catch _ {
                return false
            }
        #endif
    }
    
    
    
    
    class DiskStatus {
        
        //MARK: Formatter MB only
        class func MBFormatter(bytes: Int64) -> String {
            let formatter = NSByteCountFormatter()
            formatter.allowedUnits = NSByteCountFormatterUnits.UseMB
            formatter.countStyle = NSByteCountFormatterCountStyle.Decimal
            formatter.includesUnit = false
            return formatter.stringFromByteCount(bytes) as String
        }
        
        
        //MARK: Get String Value
        class var totalDiskSpace: String {
            get {
                return NSByteCountFormatter.stringFromByteCount(totalDiskSpaceInBytes, countStyle: NSByteCountFormatterCountStyle.Binary)
            }
        }
        
        class var freeDiskSpace: String {
            get {
                return NSByteCountFormatter.stringFromByteCount(freeDiskSpaceInBytes, countStyle: NSByteCountFormatterCountStyle.Binary)
            }
        }
        
        class var usedDiskSpace: String {
            get {
                return NSByteCountFormatter.stringFromByteCount(usedDiskSpaceInBytes, countStyle: NSByteCountFormatterCountStyle.Binary)
            }
        }
        
        
        //MARK: Get raw value
        class var totalDiskSpaceInBytes: Int64 {
            get {
                do {
                    let systemAttributes = try NSFileManager.defaultManager().attributesOfFileSystemForPath(NSHomeDirectory() as String)
                    let space = (systemAttributes[NSFileSystemSize] as? NSNumber)?.longLongValue
                    return space!
                } catch {
                    return 0
                }
            }
        }
        
        class var freeDiskSpaceInBytes: Int64 {
            get {
                do {
                    let systemAttributes = try NSFileManager.defaultManager().attributesOfFileSystemForPath(NSHomeDirectory() as String)
                    let freeSpace = (systemAttributes[NSFileSystemFreeSize] as? NSNumber)?.longLongValue
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
