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
    let form = Form()
    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "05_PassiveCheckboxJumpRules")
        moodComponent.selectMood(atIndex: 1)
    }

    func testOption1GoestToPage1() {
        MainScreen.selectOption("Option 1")
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testOption1And2GoestToPage1() {
        MainScreen.selectOption("Option 1")
        MainScreen.selectOption("Option 2")
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testOption1And3GoestToPage1() {
        MainScreen.selectOption("Option 1")
        MainScreen.selectOption("Option 3")
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testOption1And2And3GoestToPage1() {
        MainScreen.selectOption("Option 1")
        MainScreen.selectOption("Option 2")
        MainScreen.selectOption("Option 3")
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testOption2GoestToPage2() {
        MainScreen.selectOption("Option 2")
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testOption3GoestToPage2() {
        MainScreen.selectOption("Option 3")
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testNoOptionsShouldGoToEndPage() {
        form.navigationBar.nextButton.tap()
        XCTAssert(app.staticTexts["Thanks!"].exists, "It should display the end page")
    }
}
