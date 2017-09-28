//
//  02_JumpRulesOneControl.swift
//  UsabillaUITestApp
//
//  Created by Benjamin Grima on 26/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable force_cast

import XCTest

class JumpRulesOneControl: XCTestCase {

    var app: XCUIApplication!
    var moodButtons: XCUIElementQuery!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["scenario"] = "02_JumpRulesOneControl"
        app.launch()
        moodButtons = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .button)
    }

    private func selectMood(atIndex index: UInt) {
        moodButtons.element(boundBy: index).tap()
    }

    private func tapNext() {
        app.navigationBars["Feedback"].buttons["Next"].tap()
    }

    private func getTextViewText() -> String {
        let textView = XCUIApplication().tables.children(matching: .cell).element(boundBy: 0).children(matching: .textView).element
        return textView.value as! String
    }

    func testSelecting1InMoodControlTakesToPage2() {
        selectMood(atIndex: 0)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display Page 2")
    }

    func testSelecting2InMoodControlTakesToTheNextPage() {
        selectMood(atIndex: 1)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting3InMoodControlTakesToPage3() {
        selectMood(atIndex: 2)
        tapNext()
        XCTAssert(getTextViewText() == "Page 3", "It should display 'Page 3'")
    }

    func testSelecting4InMoodControlTakesToPage4() {
        selectMood(atIndex: 3)
        tapNext()
        XCTAssert(getTextViewText() == "Page 4", "It should display 'Page 4'")
    }

    func testSelecting5InMoodControlTakesToTheNextPage() {
        selectMood(atIndex: 4)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

}
