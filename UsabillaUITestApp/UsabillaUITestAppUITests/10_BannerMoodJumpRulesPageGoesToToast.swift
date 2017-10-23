//
//  10_BannerMoodJumpRulesPageGoesToToast.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerMoodJumpRulesPageGoesToToast: XCTestCase {

    let app = XCUIApplication()
    var moodButtons: XCUIElementQuery!

    private func selectMood(atIndex index: UInt) {
        moodButtons.element(boundBy: index).tap()
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.setup(type: .campaignForm, scenario: "10_BannerMoodJumpRulesPageGoesToToast")
        app.launch()
        moodButtons = app.otherElements["ratingControl"].children(matching: .other).element.children(matching: .button)
        selectMood(atIndex: 0)
    }

    func testOption1GoestToToast2() {
        MainScreen.selectOption("Option 1")
        MainScreen.tapNext()
        XCTAssert(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }

    func testOption2GoestToToast3() {
        MainScreen.selectOption("Option 2")
        MainScreen.tapNext()
        XCTAssert(app.staticTexts["Toast 3"].exists, "It should display 'Toast 3'")
    }

    func testNoOptionsGoestToToast1() {
        MainScreen.tapNext()
        XCTAssert(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }
}
