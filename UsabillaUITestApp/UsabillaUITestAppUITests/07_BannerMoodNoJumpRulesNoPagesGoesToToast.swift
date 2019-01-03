//
//  07_BannerMoodNoJumpRulesNoPagesGoesToToast.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerMoodNoJumpRulesNoPagesGoesToToast: UBXCScenario {

    let moodComponent = MoodComponentCampaign()

    override func setUp() {
        super.setUp(type: .campaignForm, scenario: "07_BannerMoodNoJumpRulesNoPagesGoesToToast")
    }

    func testMood1GoestToPage1() {
        moodComponent.selectMood(atIndex: 0, totalMoods: 5)
        verify(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood2GoestToPage1() {
        moodComponent.selectMood(atIndex: 1, totalMoods: 5)
        verify(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood3GoestToPage1() {
        moodComponent.selectMood(atIndex: 2, totalMoods: 5)
        verify(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood4GoestToPage1() {
        moodComponent.selectMood(atIndex: 3, totalMoods: 5)
        verify(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testMood5GoestToPage1() {
        moodComponent.selectMood(atIndex: 4, totalMoods: 5)
        verify(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }
}