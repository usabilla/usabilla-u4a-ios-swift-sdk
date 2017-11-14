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

        moodComponent.selectMood(atIndex: 0)
        XCTAssertEqual(moodComponent.mood!.value as! String, "Hate")
        moodComponent.selectMood(atIndex: 1)
        XCTAssertEqual(moodComponent.mood!.value as! String, "Love")
    }
}
