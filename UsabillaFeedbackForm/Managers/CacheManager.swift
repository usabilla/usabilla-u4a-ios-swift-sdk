//
//  CacheManager.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CacheManager {
    
    static let sharedInstance = CacheManager()
    let filePrefix = "usabillaFormId"
    
    private init () {
        
    }
    
    // MARK: Form Caching Methods
    func cacheForm(id: String, form: FormModel) -> Bool {
        return saveToCacheForm(id: id, formJson: form.formJsonString)
    }
    
    func getForm(id: String) -> FormModel? {
        if let jsonForm = getJsonForm(id: id) {
            return JSONFormParser.parseFormJson(jsonForm, appId: id, screenshot: nil, themeConfig: UsabillaThemeConfigurator())
        }
        
        return nil
    }
    
    func removeCachedForm(id: String) {
        removeFormId(id: id)
    }
    
    // MARK: Dictionary caching mechanism
    
    private func fileNameFormatterForForm(id: String) -> String {
        return "\(filePrefix)-\(id)"
    }

    private func getJsonForm(id: String) -> JSON? {
        print("[CacheManager] : getting \(id) from cache ⏳")
        let fileName = fileNameFormatterForForm(id: id)
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(fileName)")
            let data = try Data.init(contentsOf: fileURL)

            Swift.debugPrint("[CacheManager] : getting \(id) from cache -> done ✅")

            return JSON(data: data)
        } catch {
            Swift.debugPrint("[CacheManager] : getting \(id) from cache -> Error ❌")
        }
        
        return nil
    }
    
    private func saveToCacheForm(id: String, formJson: JSON) -> Bool {
        let fileName = fileNameFormatterForForm(id: id)
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(fileName)")
            let data = try formJson.rawData()
            try data.write(to: fileURL)
            Swift.debugPrint("[CacheManager] : saving \(id) to cache -> OK ✅")
            
            return true
        } catch {
            Swift.debugPrint("[CacheManager] : saving \(id) to cache -> Error ❌")
            return false
        }
    }
    
    
    //MARK: FileManager remove form methods
    
    // Removes cahced from with id
    private func removeFormId(id: String) {
        let fileName = fileNameFormatterForForm(id: id)
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("\(fileName)")
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            Swift.debugPrint("file deleted ✅")
        } catch {
            Swift.debugPrint("file not found ❌")
        }
    }
    
    // Removes all forms cached
    func removeAllCachedForms() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [], options: FileManager.DirectoryEnumerationOptions(rawValue: 0))
            
            if urls.count > 0 {
                for url in urls {
                    removeFileAtUrl(url: url)
                }
            }
        } catch {
            print("no url found")
        }
    }
    
    // Removes file at given Url
    private func removeFileAtUrl(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            Swift.debugPrint("file deleted ✅")
        } catch {
            Swift.debugPrint("file not found ❌")
        }
    }
}
