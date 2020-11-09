//
//  OptionsFieldModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class OptionsFieldModel: BaseFieldModel, Exportable {

    var options: [Options]
    var fieldValue: [String] = []
    var shouldRandomise: Bool

    var exportableValue: Any? {
        return fieldValue.count > 0 ? fieldValue : nil
    }
    override var serialiazedValue: [String]? {
        return fieldValue
    }

    override init(json: JSON) {
        var options: [Options] = []
        for (_, subJson): (String, JSON) in json["options"] {
            options.append(Options(title: subJson["title"].stringValue, value: subJson["value"].stringValue))
        }

        let shouldRandomise: Bool = json["random"].boolValue
        if shouldRandomise {
            options.shuffle()
        }
        self.shouldRandomise = shouldRandomise

        self.options = options
        super.init(json: json)
    }

    override func isValid() -> Bool {
        return !required || fieldValue.count > 0
    }

    override func reset() {
        fieldValue = []
    }
}
