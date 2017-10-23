//
//  09_BannerMoodJumpRulesNoPagesToToast.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerMoodJumpRulesNoPagesToToast: XCTestCase {

    let app = XCUIApplication()
    var moodButtons: XCUIElementQuery!

    private func selectMood(atIndex index: UInt) {
        moodButtons.element(boundBy: index).tap()
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.setup(type: .campaignForm, scenario: "09_BannerMoodJumpRulesNoPagesToToast")
        app.launch()
        moodButtons = app.otherElements["ratingControl"].children(matching: .other).element.children(matching: .button)
    }

    func testMood1GoestToToast1() {
        selectMood(atIndex: 0)
        XCTAssert(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood2GoestToToast1() {
        selectMood(atIndex: 1)
        XCTAssert(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood3GoestToToast1() {
        selectMood(atIndex: 2)
        XCTAssert(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood4GoestToToast2() {
        selectMood(atIndex: 3)
        XCTAssert(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }

    func testMood5GoestToToast2() {
        selectMood(atIndex: 4)
        XCTAssert(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }
}
