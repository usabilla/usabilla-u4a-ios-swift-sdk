//
//  SettingModel.swift
//  Usabilla
//
//  Created by Hitesh Jain on 08/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation

struct SettingModel: Codable {
    var settings: [Setting]
    init(settings: [Setting]) {
        self.settings = settings
    }
}

struct Setting: Codable {
    let variable: String
    let value: String
    let rules: [SettingRules]

    init(variable: String, value: String, rules: [SettingRules]) {
        self.variable = variable
        self.value = value
        self.rules = rules
    }
}

struct SettingRules: Codable {
    let name: String
    let value: String

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
