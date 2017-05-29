//
//  FormStore.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class FormStore {

    let formService: FormServiceProtocol

    init(service: FormServiceProtocol) {
        self.formService = service
    }

    // Entry to laod a form from Network or try getting it from Cache
    func loadForm(id: String, screenshot: UIImage?, theme: UsabillaTheme) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            self.formService.getForm(withId: id, screenShot: screenshot).then { form in
                UBFormDAO.shared.create(form)
                form.theme = theme
                form.updateTheme()
                PLog("  FormModel is loaded successfully")
                fulfill(form)
            }.catch { error in
                if let cachedForm = UBFormDAO.shared.read(id: id) {
                    cachedForm.theme = theme
                    cachedForm.updateTheme()
                    PLog("FormModel is loaded successfully")
                    fulfill(cachedForm)
                } else {
                    reject(error)
                }
            }
        }
    }

    // Loads the default form implemented with the app
    func loadDefaultForm(_ appId: String, screenshot: UIImage?, theme: UsabillaTheme) -> FormModel? {
        if let path = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.path(forResource: "defaultJson", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: data)
                if jsonObj != JSON.null {
                    let form = FormModel(json: jsonObj, id: appId, screenshot: screenshot)
                    form.theme = theme
                    form.updateTheme()
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
