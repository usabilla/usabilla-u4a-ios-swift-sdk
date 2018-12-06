//
//  02_JumpRulesOneControl.swift
//  UsabillaUITestApp
//
//  Created by Benjamin Grima on 26/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable force_cast

import XCTest

class JumpRulesOneControl: UBXCScenario {

    let moodComponent = MoodComponentPassive()

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "02_JumpRulesOneControl")
    }

    private func tapNext() {
        app.navigationBars["Feedback"].buttons["Next"].tap()
    }

    func testSelecting1InMoodControlTakesToPage2() {
        moodComponent.selectMood(atIndex: 0, totalMoods: 5)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display Page 2")
    }

    func testSelecting2InMoodControlTakesToTheNextPage() {
        moodComponent.selectMood(atIndex: 1, totalMoods: 5)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting3InMoodControlTakesToPage3() {
        moodComponent.selectMood(atIndex: 2, totalMoods: 5)
        tapNext()
        XCTAssert(getTextViewText() == "Page 3", "It should display 'Page 3'")
    }

    func testSelecting4InMoodControlTakesToPage4() {
        moodComponent.selectMood(atIndex: 3, totalMoods: 5)
        tapNext()
        XCTAssert(getTextViewText() == "Page 4", "It should display 'Page 4'")
    }

    func testSelecting5InMoodControlTakesToTheNextPage() {
        moodComponent.selectMood(atIndex: 4, totalMoods: 5)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }
}
