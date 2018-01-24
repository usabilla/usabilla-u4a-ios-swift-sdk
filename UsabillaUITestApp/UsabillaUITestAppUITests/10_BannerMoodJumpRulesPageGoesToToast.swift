//
//  10_BannerMoodJumpRulesPageGoesToToast.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerMoodJumpRulesPageGoesToToast: UBXCScenario {

    let mainScreen = MainScreen()
    let moodComponent = MoodComponentCampaign()
    let modal = Modal()

    override func setUp() {
        super.setUp(type: .campaignForm, scenario: "10_BannerMoodJumpRulesPageGoesToToast")
        // select first index
        moodComponent.selectMood(atIndex: 0)
    }

    func testOption1GoestToToast2() {
        mainScreen.selectOption(withLabel: "option 1, Option 1")
        modal.form.navigationBar.submitButton.tap()
        verify(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }

    func testOption2GoestToToast3() {
        mainScreen.selectOption(withLabel: "option 2, Option 2")
        modal.form.navigationBar.submitButton.tap()
        verify(app.staticTexts["Toast 3"].exists, "It should display 'Toast 3'")
    }

    func testNoOptionsGoestToToast1() {
        modal.form.navigationBar.submitButton.tap()
        //XCTAssert(self.app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
        verify(self.app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }
}
