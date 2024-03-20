//
//  FormStore.swift
//  Usabilla
//
//  Created by Adil Bougamza on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class FormStore {

    let formService: FormServiceProtocol
    init(service: FormServiceProtocol) {
        self.formService = service
    }

    private func addScreenShot(model: FormModel, image: UIImage? ) -> FormModel {
        guard let screenShotImage = image else {
            return model
        }
        var imageAdded = false
        model.pages.forEach {
            $0.fields.forEach {
                if let model = $0 as? ScreenshotModel {
                    model.image = screenShotImage
                    imageAdded = true
                }
            }
        }
        if !imageAdded {
            Swift.debugPrint("Usabilla: failed adding a provided screenshot image to the store form, as no screenshot module was found on the form")
        }
        return model

    }
    // Entry to laod a form from Network or try getting it from Cache
    func loadForm(id: String, screenshot: UIImage?, theme: UsabillaTheme, maskModel: MaskModel?) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            let client = ClientModel()
            self.formService.getForm(withID: id, screenShot: screenshot, maskModel: maskModel, client: client).then { form in
                UBFormDAO.shared.create(form)
                form.theme = theme
                form.updateTheme()
                PLog("  FormModel is loaded successfully")
                fulfill(form)
            }.catch { error in
                if var cachedForm = UBFormDAO.shared.read(id: id) {
                    cachedForm.theme = theme
                    cachedForm.updateTheme()
                    cachedForm = self.addScreenShot(model: cachedForm, image: screenshot)
                    PLog("FormModel is loaded successfully")
                    fulfill(cachedForm)
                } else {
                    reject(error)
                }
            }
        }
    }
}
