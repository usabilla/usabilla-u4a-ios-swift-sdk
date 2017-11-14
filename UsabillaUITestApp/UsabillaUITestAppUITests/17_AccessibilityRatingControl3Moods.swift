//
//  17_AccessibilityRatingControl3Moods.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 14/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class AccessibilityRatingControl3Moods: UBXCScenario {

    let moodComponent = MoodComponentPassive()

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "17_AccessibilityRatingControl3Moods")
    }

    func testMoodComponentLabelAndValues() {
        XCTAssertEqual(moodComponent.mood!.label, "select a rating out of 3")

        moodComponent.selectMood(atIndex: 0)
        XCTAssertEqual(moodComponent.mood!.value as! String, "Hate")
        moodComponent.selectMood(atIndex: 1)
        XCTAssertEqual(moodComponent.mood!.value as! String, "Neutral")
        moodComponent.selectMood(atIndex: 2)
        XCTAssertEqual(moodComponent.mood!.value as! String, "Love")
    }
}

