//
//  03_JumpRulesManyControls.swift
//  UsabillaUITestApp
//
//  Created by Benjamin Grima on 26/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable force_cast

import XCTest

class JumpRulesManyControls: UBXCScenario {

    var moodComponent = MoodComponentPassive()
    let mainScreen = MainScreen()
    let form = Form()
    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "03_JumpRulesManyControls")
    }

    func testSelecting1InMoodControlAndNoValueForTheNPSTakesToTheNextPage() {
        moodComponent.selectMood(atIndex: 0, totalMoods: 5)
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting2InMoodControlAndNoValueForTheNPSTakesToTheNextPage() {
        moodComponent.selectMood(atIndex: 1, totalMoods: 5)
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting3InMoodControlAndNoValueForTheNPSTakesToTheNextPage() {
        moodComponent.selectMood(atIndex: 2, totalMoods: 5)
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting4InMoodControlAndNoValueForTheNPSTakesToTheNextPage() {
        moodComponent.selectMood(atIndex: 3, totalMoods: 5)
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting5InMoodControlAndNoValueForTheNPSTakesToPage3() {
        moodComponent.selectMood(atIndex: 4, totalMoods: 5)
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 3", "It should display 'Page 3'")
    }

    func testSelecting1InMoodControlAnd4ForTheNPSTakesToPage4() {
        moodComponent.selectMood(atIndex: 0, totalMoods: 5)
        mainScreen.nps.select(index: 4)
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 4", "It should display 'Page 4'")
    }

    func testSelecting5InMoodControlAnd4ForTheNPSTakesToPage3() {
        moodComponent.selectMood(atIndex: 4, totalMoods: 5)
        mainScreen.nps.select(index: 4)
        form.navigationBar.nextButton.tap()
        XCTAssert(getTextViewText() == "Page 3", "It should display 'Page 3'")
    }
}
