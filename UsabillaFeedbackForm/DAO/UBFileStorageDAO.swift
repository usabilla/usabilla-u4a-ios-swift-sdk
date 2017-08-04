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
            UBFileHelper.createDirectory(url: sdkRootDirectoryUrl)
            UBFileHelper.createDirectory(url: directoryUrl)
        }
    }

    @discardableResult func create(_ obj: DataType) -> Bool {
        var isCreated = false
        fileStorageSerialQueue.sync {
            UBFileHelper.createDirectory(url: sdkRootDirectoryUrl)
            UBFileHelper.createDirectory(url: directoryUrl)
        }
        isCreated = saveToFile(id: self.id(forObj: obj), data: obj)
        return isCreated
    }

    func readAll() -> [DataType] {
        var data = [DataType]()
        var files = [String]()

        fileStorageSerialQueue.sync {
            files = UBFileHelper.filesNameIn(directory: directoryUrl)
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
        var result: DataType?

        fileStorageSerialQueue.sync {
            do {
                if let data = FileManager().contents(atPath: filePath) {
                    result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as NSData) as? DataType
                    if result == nil {
                        delete(id: id)
                    }
                }
            } catch let error {
                PLog("Error ❌ during unarchiving: \(error)")
                delete(id: id)
            }
        }

        return result
    }

    @discardableResult private func delete(id: String) -> Bool {
        let url = fileURLFor(id: id)
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch {
            PLog("Impossible to delete file at url \(url)")
        }
        return false
    }

    @discardableResult func delete(_ obj: DataType) -> Bool {
        return delete(id: id(forObj: obj))
    }

    @discardableResult func deleteAll() -> Bool {
        var isDeleted = false
        fileStorageSerialQueue.sync {
            do {
                try FileManager.default.removeItem(at: directoryUrl)
                isDeleted = true
            } catch {
                PLog("Impossible to empty directory at path \(directoryUrl)")
            }
        }
        return isDeleted
    }

    // MARK: Utility methods
    @discardableResult private func saveToFile(id: String, data: DataType) -> Bool {
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
        fatalError("func id(forObj: DataType) must be overridden")
    }
}
