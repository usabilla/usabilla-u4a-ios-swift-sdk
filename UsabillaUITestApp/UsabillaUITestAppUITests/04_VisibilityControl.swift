//
//  04_VisibilityControl.swift
//  UsabillaUITestApp
//
//  Created by Benjamin Grima on 27/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class VisibilityControl: UBXCScenario {

    var paragraph: XCUIElement!
    let moodComponent = MoodComponentPassive()
    let mainScreen = MainScreen()

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "04_VisibilityControl")
        paragraph = app.tables.children(matching: .cell).element(boundBy: 2).children(matching: .textView).element
    }

    private func displayNPSAndParagraph() {
        moodComponent.selectMood(atIndex: 4)
        mainScreen.nps.select(index: 5)
        XCTAssert(mainScreen.nps.element.isHittable, "The NPS should be visible")
        XCTAssert(paragraph.visible(), "The paragraph should be visible")
    }

    func testVisbilityControls() {
        // Selecting 1 (nothing happens - NPS and Paragraph are not visible)
        moodComponent.selectMood(atIndex: 0)
        XCTAssert(!mainScreen.nps.element.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 2 (nothing happens - NPS and Paragraph are not visible)
        moodComponent.selectMood(atIndex: 1)
        XCTAssert(!mainScreen.nps.element.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 3 (nothing happens - NPS and Paragraph are not visible)
        moodComponent.selectMood(atIndex: 2)
        XCTAssert(!mainScreen.nps.element.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 4 (nothing happens - NPS and Paragraph are not visible)
        moodComponent.selectMood(atIndex: 3)
        XCTAssert(!mainScreen.nps.element.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 5 in Mood Control displays NPS
        moodComponent.selectMood(atIndex: 4)
        XCTAssert(mainScreen.nps.element.isHittable, "The NPS should be visible")

        // Selecting 5 in NPS displays Paragraph
        mainScreen.nps.select(index: 5)
        XCTAssert(paragraph.visible(), "The paragraph should be visible")

        // Selecting 1 (2, 3 or 4) in Mood Control hides NPS and Paragraph
        moodComponent.selectMood(atIndex: 0)
        XCTAssert(!mainScreen.nps.element.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 2 in Mood Control hides NPS and Paragraph
        displayNPSAndParagraph()
        moodComponent.selectMood(atIndex: 1)
        XCTAssert(!mainScreen.nps.element.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 3 in Mood Control hides NPS and Paragraph
        displayNPSAndParagraph()
        moodComponent.selectMood(atIndex: 2)
        XCTAssert(!mainScreen.nps.element.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 4 in Mood Control hides NPS Paragraph
        displayNPSAndParagraph()
        moodComponent.selectMood(atIndex: 3)
        XCTAssert(!mainScreen.nps.element.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 5 in Mood Control displays only NPS and not the Paragraph
        moodComponent.selectMood(atIndex: 4)
        XCTAssert(mainScreen.nps.element.isHittable, "The NPS should be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")
    }
}
