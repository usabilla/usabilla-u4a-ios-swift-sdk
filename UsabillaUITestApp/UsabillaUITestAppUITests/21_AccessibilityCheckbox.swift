//
//  21_AccessibilityCheckbox.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 07/12/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class AccessibilityCheckbox: UBXCScenario {

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "21_AccessibilityCheckbox")
    }

    func testCheckBoxes() {
        let option1 = app.tables.otherElements["option 1, dog"]
        let option2 = app.tables.otherElements["option 2, cat"]
        let option3 = app.tables.otherElements["option 3, kangaroo"]

        // check component title
        let textAreaCell = app.tables.cells.element(boundBy: 1)
        XCTAssertEqual(textAreaCell.label, "choose an animal from the checkbox component, Choose from 3 options, Multiple options possible")

        // check options exist
        XCTAssert(option1.exists)
        XCTAssert(option2.exists)
        XCTAssert(option3.exists)

        // check all options are unselected
        XCTAssertEqual(option1.value as! String, "unselected")
        XCTAssertEqual(option2.value as! String, "unselected")
        XCTAssertEqual(option3.value as! String, "unselected")

        // select option 1
        option1.tap()
        XCTAssertEqual(option1.value as! String, "selected")
        XCTAssertEqual(option2.value as! String, "unselected")
        XCTAssertEqual(option3.value as! String, "unselected")

        // select option 3
        option3.tap()
        XCTAssertEqual(option1.value as! String, "selected")
        XCTAssertEqual(option2.value as! String, "unselected")
        XCTAssertEqual(option3.value as! String, "selected")

        // unselect option 2
        option1.tap()
        XCTAssertEqual(option1.value as! String, "unselected")
        XCTAssertEqual(option2.value as! String, "unselected")
        XCTAssertEqual(option3.value as! String, "selected")
    }
}
