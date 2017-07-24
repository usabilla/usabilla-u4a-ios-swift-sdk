//
//  FieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

protocol FieldModelProtocol {
    unowned var pageModel: PageModel {get set}
    var fieldId: String {get set}
    var fieldTitle: String {get set}
    var required: Bool {get set}

    var type: String {get set}
    var rule: ShowHideRule? {get set}

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
