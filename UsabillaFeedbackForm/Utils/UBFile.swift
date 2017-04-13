//
//  UBFile.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFile {

    @discardableResult class func deleteDirectory(url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch let error as NSError {
            PLog("Error deleting directory: \(error.localizedDescription)")
        }
        return false
    }

    @discardableResult class func createDirectory (url: URL) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch let error as NSError {
            PLog("Error creating directory: \(error.localizedDescription)")
        }
        return false
    }

    class func nameOfFilesIn(directory directoryURL: URL) -> [String] {
        PLog("listing \(directoryURL)")
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [])
            return urls.map { $0.lastPathComponent }
        } catch let error as NSError {
            PLog("Error listing directory: \(error.localizedDescription)")
        }
        return []
    }
}
