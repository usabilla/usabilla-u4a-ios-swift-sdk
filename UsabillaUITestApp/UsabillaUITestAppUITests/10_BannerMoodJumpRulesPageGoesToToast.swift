//
//  10_BannerMoodJumpRulesPageGoesToToast.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerMoodJumpRulesPageGoesToToast: UBXCScenario {

    let moodComponent = MoodComponentCampaign()

    override func setUp() {
        scenario = "10_BannerMoodJumpRulesPageGoesToToast"
        super.setUp(type: .campaignForm)
        // select first index
        moodComponent.selectMood(atIndex: 0)
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
