//
//  CampaignModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class Campaign {
    let id: String
    let form: FormModel
    
    init(id: String, json: JSON) {
        self.form = FormModel(json: json, id: id, themeConfig: UsabillaThemeConfigurator(), screenshot: nil)
        self.id = id
    }
}
