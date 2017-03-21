//
//  FormStore.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class FormStore {
    
    var defaultForm: FormModel?
    var form: FormModel?
    static let sharedInstance = FormStore()
    
    // MARK: init Methods
    private init() {
        
    }
    
    // Entry to laod a form from Network or try getting it from Cache
    func loadForm(id: String, screenshot: UIImage?, customVariables: [String: Any]?, themeConfig: UsabillaThemeConfigurator) -> Promise<FormModel> {
        // 1. try loading form from network if success return it
        // 2. else try loading form from cache if succeeded return it
        // 3. else fail
        return Promise { fulfill, reject in
            NetworkManager.getForm(id, screenshot: screenshot, customVariables: customVariables, themeConfig: themeConfig).then(execute: { form in
                self.form = form
                let _ = CacheManager.sharedInstance.cacheForm(id: form.appId, form: form)
                Swift.debugPrint("FormModel is loaded successfully")
                fulfill(form)
            }).catch(execute: { error in
                if let cachedForm = CacheManager.sharedInstance.getForm(id: id) {
                    self.form = cachedForm
                    fulfill(cachedForm)
                } else {
                    reject(error)
                }
            })
        }
    }
    
    // Loads the default form implemented with the app
    func loadDefaultForm(_ appId: String, screenshot: UIImage?, customVariables: [String: Any]?, themeConfig: UsabillaThemeConfigurator) -> FormModel? {
        if let path = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.path(forResource: "defaultJson", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: data)
                if jsonObj != JSON.null {
                    let form: FormModel = JSONFormParser.parseFormJson(jsonObj, appId: appId, screenshot: screenshot, themeConfig: themeConfig)
                    form.isDefault = true
                    defaultForm = form
                    return form
                } else {
                    Swift.debugPrint("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }
        } else {
            Swift.debugPrint("Invalid filename/path.")
        }
        
        return nil
    }
}
