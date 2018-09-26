//
//  19_AccessibilityRatingControl5Stars.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 14/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class AccessibilityRatingControl5Stars: UBXCScenario {

    let moodComponent = MoodComponentPassive()

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "19_AccessibilityRatingControl5Stars")
    }

    func testMoodComponentLabelAndValues() {
        XCTAssertEqual(moodComponent.mood!.label, "select a rating out of 5")

        moodComponent.selectMood(atIndex: 0)
        XCTAssertEqual(moodComponent.mood!.value as! String, Star.oneStar.rawValue)
        moodComponent.selectMood(atIndex: 1)
        XCTAssertEqual(moodComponent.mood!.value as! String, Star.twoStars.rawValue)
        moodComponent.selectMood(atIndex: 2)
        XCTAssertEqual(moodComponent.mood!.value as! String, Star.threeStars.rawValue)
        moodComponent.selectMood(atIndex: 3)
        XCTAssertEqual(moodComponent.mood!.value as! String, Star.fourStars.rawValue)
        moodComponent.selectMood(atIndex: 4)
        XCTAssertEqual(moodComponent.mood!.value as! String, Star.fiveStars.rawValue)
    }
}

