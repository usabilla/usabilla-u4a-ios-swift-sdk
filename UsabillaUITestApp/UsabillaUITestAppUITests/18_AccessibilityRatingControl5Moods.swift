//
//  18_AccessibilityRatingControl5Moods.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 14/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class AccessibilityRatingControl5Moods: UBXCScenario {

    let moodComponent = MoodComponentPassive()

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "18_AccessibilityRatingControl5Moods")
    }

    func testMoodComponentLabelAndValues() {
        XCTAssertEqual(moodComponent.mood!.label, "select a rating out of 5")

        moodComponent.selectMood(atIndex: 0, totalMoods: 5)
        XCTAssertEqual(moodComponent.mood!.value as! String, Mood.hate.rawValue)
        moodComponent.selectMood(atIndex: 1, totalMoods: 5)
        XCTAssertEqual(moodComponent.mood!.value as! String, Mood.dislike.rawValue)
        moodComponent.selectMood(atIndex: 2, totalMoods: 5)
        XCTAssertEqual(moodComponent.mood!.value as! String, Mood.neutral.rawValue)
        moodComponent.selectMood(atIndex: 3, totalMoods: 5)
        XCTAssertEqual(moodComponent.mood!.value as! String, Mood.like.rawValue)
        moodComponent.selectMood(atIndex: 4, totalMoods: 5)
        XCTAssertEqual(moodComponent.mood!.value as! String, Mood.love.rawValue)
    }
}

