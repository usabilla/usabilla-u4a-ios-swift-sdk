//
//  FormStore.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class FormStore {

    // Entry to laod a form from Network or try getting it from Cache
    class func loadForm(id: String, screenshot: UIImage?, customVariables: [String: Any]?, theme: UsabillaTheme) -> Promise<FormModel> {
        // 1. try loading form from network if success return it
        // 2. else try loading form from cache if succeeded return it
        // 3. else fail
        return Promise { fulfill, reject in
            NetworkManager.getForm(id, screenshot: screenshot, customVariables: customVariables, theme: theme).then(execute: { form in
                UBFormDAO.shared.create(form)
                PLog("  FormModel is loaded successfully")
                fulfill(form)
            }).catch(execute: { error in
                if let cachedForm = UBFormDAO.shared.read(id: id) {
                    fulfill(cachedForm)
                } else {
                    reject(error)
                }
            })
        }
    }

    // Loads the default form implemented with the app
    class func loadDefaultForm(_ appId: String, screenshot: UIImage?, customVariables: [String: Any]?, theme: UsabillaTheme) -> FormModel? {
        if let path = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.path(forResource: "defaultJson", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: data)
                if jsonObj != JSON.null {
                    let form = FormModel(json: jsonObj, id: appId, screenshot: screenshot)
                    form.isDefault = true
                    return form
                } else {
                    PLog("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                PLog(error.localizedDescription)
            }
        } else {
            PLog("Invalid filename/path.")
        }

        return nil
    }
}
