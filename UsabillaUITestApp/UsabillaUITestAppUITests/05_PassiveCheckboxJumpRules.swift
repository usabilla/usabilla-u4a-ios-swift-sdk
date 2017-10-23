//
//  05_PassiveCheckboxJumpRules.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class PassiveCheckboxJumpRules: XCTestCase {

    let app = XCUIApplication()
    var moodButtons: XCUIElementQuery!

    private func selectMood(atIndex index: UInt) {
        moodButtons.element(boundBy: index).tap()
    }

    private func getTextViewText() -> String {
        let textView = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .textView).element
        return textView.value as! String
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.setup(type: .passiveForm, scenario: "05_PassiveCheckboxJumpRules")
        app.launch()
        moodButtons = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .button)
        selectMood(atIndex: 1)
    }

    func testOption1GoestToPage1() {
        MainScreen.selectOption("Option 1")
        MainScreen.tapNext()
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testOption1And2GoestToPage1() {
        MainScreen.selectOption("Option 1")
        MainScreen.selectOption("Option 2")
        MainScreen.tapNext()
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testOption1And3GoestToPage1() {
        MainScreen.selectOption("Option 1")
        MainScreen.selectOption("Option 3")
        MainScreen.tapNext()
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testOption1And2And3GoestToPage1() {
        MainScreen.selectOption("Option 1")
        MainScreen.selectOption("Option 2")
        MainScreen.selectOption("Option 3")
        MainScreen.tapNext()
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testOption2GoestToPage2() {
        MainScreen.selectOption("Option 2")
        MainScreen.tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testOption3GoestToPage2() {
        MainScreen.selectOption("Option 3")
        MainScreen.tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testNoOptionsShouldGoToEndPage() {
        MainScreen.tapNext()
        XCTAssert(app.staticTexts["Thanks!"].exists, "It should display the end page")
    }
}
