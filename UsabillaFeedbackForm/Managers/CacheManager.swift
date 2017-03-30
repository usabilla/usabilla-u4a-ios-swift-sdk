//
//  CacheManager.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CacheManager {

    static let shared = CacheManager()
    let filePrefix = "usabillaFormId"
    let formsCacheFolder: URL?

    private init () {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        formsCacheFolder = documentsDirectory.appendingPathComponent("FormsCache")

        createFormsDirectory()
    }

    func createFormsDirectory () {
        do {
            try FileManager.default.createDirectory(atPath: formsCacheFolder!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            PLog("Error creating directory: \(error.localizedDescription)")
        }
    }

    // MARK: Form Caching Methods
    @discardableResult func cacheForm(id: String, form: FormModel) -> Bool {
        createFormsDirectory()

        let fileName = fileNameFormatterForForm(id: id)
        return saveToCacheForm(id: fileName, formJson: form.formJsonString)
    }

    func getForm(id: String) -> FormModel? {
        let fileName = fileNameFormatterForForm(id: id)
        if let jsonForm = getJsonForm(id: fileName) {
            return FormModel(json: jsonForm, id: id, themeConfig: UsabillaThemeConfigurator(), screenshot: nil)
        }

        return nil
    }

    @discardableResult func removeCachedForm(id: String) -> Bool {
        let fileName = fileNameFormatterForForm(id: id)
        return removeFormId(id: fileName)
    }

    // MARK: Dictionary caching mechanism

    private func fileNameFormatterForForm(id: String) -> String {
        return "\(filePrefix)-\(id)"
    }

    private func getJsonForm(id: String) -> JSON? {
        PLog("[CacheManager] : getting \(id) from cache ⏳")
        do {
            let fileURL = formsCacheFolder!.appendingPathComponent("\(id)")
            let data = try Data.init(contentsOf: fileURL)

            PLog("[CacheManager] : getting \(id) from cache -> done ✅")

            return JSON(data: data)
        } catch {
            PLog("[CacheManager] : getting \(id) from cache -> Error ❌")
        }

        return nil
    }

    private func saveToCacheForm(id: String, formJson: JSON) -> Bool {
        do {
            let fileURL = formsCacheFolder?.appendingPathComponent("\(id)")
            let data = try formJson.rawData()
            try data.write(to: fileURL!)
            PLog("[CacheManager] : saving \(id) to cache -> OK ✅")

            return true
        } catch {
            PLog("[CacheManager] : saving \(id) to cache -> Error ❌")
            return false
        }
    }

    // MARK: FileManager remove form methods

    // Removes cahced from with id
    @discardableResult private func removeFormId(id: String) -> Bool {
        let fileURL = formsCacheFolder?.appendingPathComponent("\(id)")

        return removeFileAtUrl(url: fileURL!)
    }

    // Removes all forms cached
    @discardableResult func removeAllCachedForms() -> Bool {
        return removeFileAtUrl(url: formsCacheFolder!)
    }

    // Removes file at given Url
    @discardableResult private func removeFileAtUrl(url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            PLog("file deleted ✅")
            return true
        } catch {
            PLog("file not found ❌")
            return false
        }
    }
}
