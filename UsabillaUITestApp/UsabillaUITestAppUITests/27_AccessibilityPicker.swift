//
//  26_AccessibilityPicker.swift
//  UsabillaUITestAppUITests
//

import XCTest

class AccessibilityPicker: UBXCScenario {

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "27_AccessibilityPicker")
    }

    /**
     *   The picker component accessibility label was changed from iOS 10.* To iOS 11.
     *   These tests run successfully only on iOS 11.
     */
    func testPickerOptionsAreAccessible() {
        if #available(iOS 11.0, *) {
            let picker = app.tables.otherElements["pickerComponent"].pickerWheels.firstMatch
            let button = app.buttons["Please choose an option"]

            XCTAssertEqual(button.label, "Please choose an option")
            button.tap()
            Application.xcApp.tables.children(matching: .cell).otherElements["pickerComponent"].tap()

            picker.adjust(toPickerWheelValue: "Option 2")
            XCTAssertEqual(picker.value as! String, "Option 2")

            picker.adjust(toPickerWheelValue: "Option 1")
            XCTAssertEqual(picker.value as! String, "Option 1")

            picker.adjust(toPickerWheelValue: "Option 3")
            XCTAssertEqual(picker.value as! String, "Option 3")
        } else {
            XCTAssertTrue(true)
        }
    }

    func testPickerOptionsAreNotAccessibleIfPickerIsNotExpanded() {
        if #available(iOS 11.0, *) {
            let picker = app.tables.otherElements["pickerComponent"].pickerWheels.firstMatch
            let button = app.buttons["Please choose an option"]

            XCTAssertEqual(button.label, "Please choose an option")
            XCTAssertFalse(picker.visible())
        } else {
            XCTAssertTrue(true)
        }
    }
}
