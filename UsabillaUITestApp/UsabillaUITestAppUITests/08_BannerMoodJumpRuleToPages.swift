//
//  08_BannerMoodJumpRuleToPages.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerMoodJumpRuleToPages: UBXCScenario {

    let moodComponent = MoodComponentCampaign()

    override func setUp() {
        super.setUp(type: .campaignForm, scenario: "08_BannerMoodJumpRuleToPages")
    }

    func testMood1GoestToPage1() {
        moodComponent.selectMood(atIndex: 0)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testMood2GoestToPage1() {
        moodComponent.selectMood(atIndex: 1)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testMood3GoestToPage1() {
        moodComponent.selectMood(atIndex: 2)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testMood4GoestToPage2() {
        moodComponent.selectMood(atIndex: 3)
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testMood5GoestToPage2() {
        moodComponent.selectMood(atIndex: 4)
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }
}
