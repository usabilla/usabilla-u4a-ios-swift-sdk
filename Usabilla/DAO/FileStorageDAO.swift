//
//  FileStorageDAO.swift
//  Usabilla
//
//  Created by Hitesh Jain on 28/04/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

class FileStorageDAO<ModelType: Codable>: UBDAO {
    typealias DataType = ModelType

    let directory: DirectoryProtocol
    let sdkRootDirectoryUrl: URL
    let directoryUrl: URL

    init(directory: DirectoryProtocol) {
        self.directory = directory
        // swiftlint:disable:next force_unwrapping
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        sdkRootDirectoryUrl = documentsDirectory.appendingPathComponent(kSDKRootDirectoryName)
        directoryUrl = sdkRootDirectoryUrl.appendingPathComponent(directory.name)

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
            if let data = FileManager().contents(atPath: filePath) {
                do {
                    result = try PropertyListDecoder().decode(DataType.self, from: data)
                if result == nil {
                    DLogError("Couldn't load \(directory.description) with id: \(id) from database")
                    PLog("Error ❌ during unarchiving: data not found")
                    delete(id: id)
                    }
                } catch {
                    PLog("Error ❌ during unarchiving: \(error)")
                    delete(id: id)
                }
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

    @discardableResult func deleteAll(completion: (() -> Void)? = nil) -> Bool {
        var isDeleted = false
        fileStorageSerialQueue.sync {
            do {
                try FileManager.default.removeItem(at: directoryUrl)
                isDeleted = true
                completion?()
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
            do {
                let newData = try PropertyListEncoder().encode(data)
                didSave = FileManager.default.createFile(atPath: filePath, contents: newData, attributes: nil)
                if didSave {
                    PLog("[CacheManager] : saving \(id) to cache -> OK ✅")
                } else {
                    PLog("[CacheManager] : saving \(id) to cache -> Error ❌")
                }
            } catch {
                PLog("Impossible to empty directory at path \(directoryUrl)")
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
