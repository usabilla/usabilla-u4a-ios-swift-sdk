//
//  UBFileStorageDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFileStorageDAO<ModelType: NSCoding>: UBDAO {
    typealias DataType = ModelType

    var directoryName: String
    let directoryUrl: URL

    init(directoryName: String) {
        self.directoryName = directoryName

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        directoryUrl = documentsDirectory.appendingPathComponent(directoryName)

        createDirectory(url: directoryUrl)
    }

    @discardableResult func create(_ obj: DataType) -> Bool {
        createDirectory(url: directoryUrl)
        return self.saveToFile(id: self.id(forObj: obj), data: obj)
    }

    func readAll() -> [DataType] {
        var data = [DataType]()
        let files = fileNameInDirectory()
        files.forEach {
            if let item = read(id: $0) {
                data.append(item)
            }
        }

        return data
    }

    func read(id: String) -> DataType? {
        let filePath = self.filePathFor(id: id)
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? DataType
    }

    @discardableResult func delete(_ obj: DataType) -> Bool {
        let path = filePathFor(id: id(forObj: obj))
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            PLog("Impossible to delete file at path \(path)")
            return false
        }
    }

    @discardableResult func deleteAll() -> Bool {
        do {
            try FileManager.default.removeItem(at: directoryUrl)
            return true
        } catch {
            PLog("Impossible to empty directory at path \(directoryUrl)")
            return false
        }
    }

    // MARK: Utility methods
    @discardableResult func createDirectory (url: URL) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch let error as NSError {
            PLog("Error creating directory: \(error.localizedDescription)")
            return false
        }
    }

    @discardableResult func saveToFile(id: String, data: DataType) -> Bool {
        let filePath = filePathFor(id: id)
        let didSave = NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
        if didSave {
            PLog("[CacheManager] : saving \(id) to cache -> OK ✅")
        } else {
            PLog("[CacheManager] : saving \(id) to cache -> Error ❌")
        }
        return didSave
    }

    func filePathFor(id: String) -> String {
        return directoryUrl.appendingPathComponent("\(id)").path
    }

    func fileNameInDirectory() -> [String] {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil, options: [])
            return urls.map { $0.lastPathComponent }
        } catch let error as NSError {
            PLog("Error listing directory: \(error.localizedDescription)")
        }
        return []
    }

    func id(forObj: DataType) -> String {
        return ""
    }
}
