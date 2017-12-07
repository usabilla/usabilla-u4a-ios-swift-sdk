//
//  22_AccessibilityRadioButton.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 07/12/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class AccessibilityRadioButton: UBXCScenario {

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "22_AccessibilityRadioButton")
    }

    func testRadioButtons() {
        let option1 = app.tables.otherElements["option 1, dragon"]
        let option2 = app.tables.otherElements["option 2, monkey"]

        // check options exist
        XCTAssert(option1.exists)
        XCTAssert(option2.exists)

        // check all options are unselected
        XCTAssertEqual(option1.value as! String, "unselected")
        XCTAssertEqual(option2.value as! String, "unselected")

        // select option 1
        option1.tap()
        XCTAssertEqual(option1.value as! String, "selected")
        XCTAssertEqual(option2.value as! String, "unselected")

        // select option 3
        option2.tap()
        XCTAssertEqual(option1.value as! String, "unselected")
        XCTAssertEqual(option2.value as! String, "selected")
    }
}
