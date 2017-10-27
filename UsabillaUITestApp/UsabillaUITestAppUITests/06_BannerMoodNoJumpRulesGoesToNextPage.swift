//
//  06_BannerMoodNoJumpRulesGoesToNextPage.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerMoodNoJumpRulesGoesToNextPage: UBXCScenario {

    let moodComponent = MoodComponent()

    override func setUp() {
        scenario = "06_BannerMoodNoJumpRulesGoesToNextPage"
        super.setUp()
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

    func testMood4GoestToPage1() {
        moodComponent.selectMood(atIndex: 3)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testMood5GoestToPage1() {
        moodComponent.selectMood(atIndex: 4)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }
}
