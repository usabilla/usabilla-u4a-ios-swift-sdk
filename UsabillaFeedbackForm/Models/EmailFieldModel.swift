//
//  EmailFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class EmailFieldModel: StringFieldModel, EditableStringComponentModel {
    let placeHolder: String?

    override init(json: JSON, pageModel: PageModel) {
        placeHolder = json["placeholder"].string
        super.init(json: json, pageModel: pageModel)
    }

    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || (fieldValue != nil && fieldValue!.characters.count > 0 && isValidEmail(testStr: fieldValue!))
        return isModelValid
    }

    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
