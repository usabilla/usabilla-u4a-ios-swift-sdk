//
//  09_BannerMoodJumpRulesNoPagesToToast.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerMoodJumpRulesNoPagesToToast: UBXCScenario {

    let moodComponent = MoodComponent()

    override func setUp() {
        scenario = "09_BannerMoodJumpRulesNoPagesToToast"
        super.setUp()
    }

    func testMood1GoestToToast1() {
        moodComponent.selectMood(atIndex: 0)
        XCTAssert(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood2GoestToToast1() {
        moodComponent.selectMood(atIndex: 1)
        XCTAssert(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood3GoestToToast1() {
        moodComponent.selectMood(atIndex: 2)
        XCTAssert(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood4GoestToToast2() {
        moodComponent.selectMood(atIndex: 3)
        XCTAssert(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }

    func testMood5GoestToToast2() {
        moodComponent.selectMood(atIndex: 4)
        XCTAssert(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }
}
