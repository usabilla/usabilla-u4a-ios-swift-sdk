//
//  08_BannerMoodJumpRuleToPages.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerMoodJumpRuleToPages: XCTestCase {

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
        app.setup(type: .campaignForm, scenario: "08_BannerMoodJumpRuleToPages")
        app.launch()
        moodButtons = app.otherElements["ratingControl"].children(matching: .other).element.children(matching: .button)
    }

    func testMood1GoestToPage1() {
        selectMood(atIndex: 0)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testMood2GoestToPage1() {
        selectMood(atIndex: 1)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testMood3GoestToPage1() {
        selectMood(atIndex: 2)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testMood4GoestToPage2() {
        selectMood(atIndex: 3)
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testMood5GoestToPage2() {
        selectMood(atIndex: 4)
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }
}
