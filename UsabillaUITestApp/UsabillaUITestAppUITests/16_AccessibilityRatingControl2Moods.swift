//
//  16_AccessibilityRatingControl2Moods.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 14/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class AccessibilityRatingControl2Moods: UBXCScenario {

    let moodComponent = MoodComponentPassive()

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "16_AccessibilityRatingControl2Moods")
    }

    func testMoodComponentLabelAndValues() {
        XCTAssertEqual(moodComponent.mood!.label, "select a rating out of 2")

 //       XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["01_FormAppearance"]/*[[".buttons[\"Scenario 1\"]",".buttons[\"01_FormAppearance\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        moodComponent.selectMood(atIndex: 0, totalMoods: 2)
        XCTAssertEqual(moodComponent.mood!.value as! String, Mood.hate.rawValue)
        moodComponent.selectMood(atIndex: 1, totalMoods: 2)
        XCTAssertEqual(moodComponent.mood!.value as! String, Mood.love.rawValue)
    }
}
