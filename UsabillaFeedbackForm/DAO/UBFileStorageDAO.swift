//
//  UBFileStorageDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

let kSDKRootDirectoryName = "UBSDK"

let fileStorageSerialQueue = DispatchQueue(label: "com.usabilla.u4a.storage")

class UBFileStorageDAO<ModelType: NSCoding>: UBDAO {

    typealias DataType = ModelType

    let directoryName: String
    let sdkRootDirectoryUrl: URL
    let directoryUrl: URL

    init(directoryName: String) {
        self.directoryName = directoryName

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        sdkRootDirectoryUrl = documentsDirectory.appendingPathComponent(kSDKRootDirectoryName)
        directoryUrl = sdkRootDirectoryUrl.appendingPathComponent(directoryName)

        fileStorageSerialQueue.sync {
            UBFile.createDirectory(url: sdkRootDirectoryUrl)
            UBFile.createDirectory(url: directoryUrl)
        }
    }

    @discardableResult func create(_ obj: DataType) -> Bool {
        var res = false
        fileStorageSerialQueue.sync {
            UBFile.createDirectory(url: sdkRootDirectoryUrl)
            UBFile.createDirectory(url: directoryUrl)
        }
        res = saveToFile(id: self.id(forObj: obj), data: obj)
        return res
    }

    func readAll() -> [DataType] {
        var data = [DataType]()
        var files = [String]()

        fileStorageSerialQueue.sync {
            files = UBFile.nameOfFilesIn(directory: directoryUrl)
        }

        files.forEach {
            if let item = read(id: $0) {
                data.append(item)
            }
        }

        return data
    }

    func read(id: String) -> DataType? {
        let filePath = fileURLFor(id: id).path
        var res: DataType?

        fileStorageSerialQueue.sync {
            res = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? DataType
        }

        return res
    }

    @discardableResult func delete(_ obj: DataType) -> Bool {
        let url = fileURLFor(id: id(forObj: obj))
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch {
            PLog("Impossible to delete file at url \(url)")
        }
        return false
    }

    @discardableResult func deleteAll() -> Bool {
        var res = false
        fileStorageSerialQueue.sync {
            do {
                try FileManager.default.removeItem(at: directoryUrl)
                res = true
            } catch {
                PLog("Impossible to empty directory at path \(directoryUrl)")
            }
        }
        return res
    }

    // MARK: Utility methods
    @discardableResult func saveToFile(id: String, data: DataType) -> Bool {
        let filePath = fileURLFor(id: id).path

        var didSave = false
        fileStorageSerialQueue.sync {
            didSave = NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
            if didSave {
                PLog("[CacheManager] : saving \(id) to cache -> OK ✅")
            } else {
                PLog("[CacheManager] : saving \(id) to cache -> Error ❌")
            }
        }
        return didSave
    }

    func fileURLFor(id: String) -> URL {
        return directoryUrl.appendingPathComponent("\(id)")
    }

    func id(forObj: DataType) -> String {
        return ""
    }
}
