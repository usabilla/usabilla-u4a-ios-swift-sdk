//
//  EmailFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class EmailFieldModel: StringFieldModel, EditableStringComponentModel, Exportable {
    let placeHolder: String?

    var exportableValue: Any? {
        return fieldValue
    }

    override init(json: JSON) {
        placeHolder = json["placeholder"].string
        super.init(json: json)
    }

    override func isValid() -> Bool {
        // swiftlint:disable:next force_unwrapping
        return !required || (fieldValue != nil && fieldValue!.count > 0 && isValidEmail(testStr: fieldValue!))
    }

    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}