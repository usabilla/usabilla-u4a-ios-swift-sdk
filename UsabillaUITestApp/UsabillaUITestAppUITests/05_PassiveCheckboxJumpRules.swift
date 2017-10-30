//
//  05_PassiveCheckboxJumpRules.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class PassiveCheckboxJumpRules: UBXCScenario {

    let moodComponent = MoodComponentPassive()

    override func setUp() {
        scenario = "05_PassiveCheckboxJumpRules"
        super.setUp(type: .passiveForm)
        moodComponent.selectMood(atIndex: 1)
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
