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
        print(String(describing: type(of: self)))
        return self.saveToFile(id: "", data: obj)
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

    func update(_ obj: DataType) {

    }

    func delete(_ obj: DataType) {

    }

    func deleteAll() {

    }

    // MARK: Utility methods
    func createDirectory (url: URL) {
        do {
            try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            PLog("Error creating directory: \(error.localizedDescription)")
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
