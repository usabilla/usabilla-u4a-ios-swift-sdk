//
//  UBXCScenario.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 27/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class UBXCScenario: XCTestCase {
    let app = Application.xcApp
    var scenario: String?

    func setUp(type: FormType) {
        super.setUp()
        continueAfterFailure = false
        app.setup(type: type, scenario: scenario!)
        app.launch()
    }

    func getTextViewText() -> String {
        let textView = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .textView).element
        return textView.value as! String
    }
}
