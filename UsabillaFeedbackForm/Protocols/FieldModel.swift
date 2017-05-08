//
//  FieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

protocol FieldModelProtocol {

    var isViewCurrentlyVisible: Bool {set get}
    unowned var themeConfig: UsabillaThemeConfigurator {get set}
    unowned var pageModel: PageModel {set get}
    var fieldId: String {set get}
    var fieldTitle: String {set get}
    var required: Bool {set get}

    var type: String {set get}
    var rule: ShowHideRule? {set get}
    var isModelValid: Bool {set get}

    func isValid() -> Bool
    func convertToJSON() -> Any?
    func reset()
}

struct Options {

    let title: String
    let value: String

    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
