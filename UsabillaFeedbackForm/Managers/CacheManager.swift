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
        let fileName = fileNameFormatterForForm(id: id)
        return saveToCacheForm(id: fileName, formJson: form.formJsonString)
    }
    
    func getForm(id: String) -> FormModel? {
        let fileName = fileNameFormatterForForm(id: id)
        if let jsonForm = getJsonForm(id: fileName) {
            return JSONFormParser.parseFormJson(jsonForm, appId: id, screenshot: nil, themeConfig: UsabillaThemeConfigurator())
        }
        
        return nil
    }
    
    func removeCachedForm(id: String) -> Bool {
        let fileName = fileNameFormatterForForm(id: id)
        return removeFormId(id: fileName)
    }
    
    // MARK: Dictionary caching mechanism
    
    private func fileNameFormatterForForm(id: String) -> String {
        return "\(filePrefix)-\(id)"
    }

    private func getJsonForm(id: String) -> JSON? {
        print("[CacheManager] : getting \(id) from cache ⏳")
        
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(id)")
            let data = try Data.init(contentsOf: fileURL)

            Swift.debugPrint("[CacheManager] : getting \(id) from cache -> done ✅")

            return JSON(data: data)
        } catch {
            Swift.debugPrint("[CacheManager] : getting \(id) from cache -> Error ❌")
        }
        
        return nil
    }
    
    private func saveToCacheForm(id: String, formJson: JSON) -> Bool {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(id)")
            let data = try formJson.rawData()
            try data.write(to: fileURL)
            Swift.debugPrint("[CacheManager] : saving \(id) to cache -> OK ✅")
            
            return true
        } catch {
            Swift.debugPrint("[CacheManager] : saving \(id) to cache -> Error ❌")
            return false
        }
    }
    
    
    // MARK: FileManager remove form methods
    
    // Removes cahced from with id
    private func removeFormId(id: String) -> Bool {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("\(id)")
        
        return removeFileAtUrl(url: fileURL)
    }
    
    // Removes all forms cached
    func removeAllCachedForms() -> Bool {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var removeSucceeded = false
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [], options: FileManager.DirectoryEnumerationOptions(rawValue: 0))
            
            if urls.count > 0 {
                for url in urls {
                    if url.absoluteString.contains(filePrefix) {
                        print("removing this form id : \(url.absoluteString)")
                        _ = removeFileAtUrl(url: url)
                        removeSucceeded = true
                    }
                }
                
                return removeSucceeded
            } else {
                Swift.debugPrint("No form cache found")
            }
        } catch {
            print("no url found")
        }
        
        return false
    }
    
    // Removes file at given Url
    private func removeFileAtUrl(url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            Swift.debugPrint("file deleted ✅")
            return true
        } catch {
            Swift.debugPrint("file not found ❌")
            return false
        }
    }
}
