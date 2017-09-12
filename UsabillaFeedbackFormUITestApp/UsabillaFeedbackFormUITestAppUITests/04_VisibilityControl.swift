//
//  04_VisibilityControl.swift
//  UsabillaFeedbackFormUITestApp
//
//  Created by Benjamin Grima on 27/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class VisibilityControl: XCTestCase {

    var app: XCUIApplication!
    var paragraph: XCUIElement!
    var moodButtons: XCUIElementQuery!
    let mainScreen = MainScreen()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["scenario"] = "04_VisibilityControl"
        app.launch()

        paragraph = app.tables.children(matching: .cell).element(boundBy: 2).children(matching: .textView).element
        moodButtons = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .button)
    }

    private func selectMood(atIndex index: UInt) {
        moodButtons.element(boundBy: index).tap()
    }

    private func selectNPS(withValue value: CGFloat) {
        mainScreen.nps.adjust(toNormalizedSliderValue: value)
    }

    private func displayNPSAndParagraph() {
        selectMood(atIndex: 4)
        selectNPS(withValue: 0.5)
        XCTAssert(mainScreen.nps.isHittable, "The NPS should be visible")
        XCTAssert(paragraph.visible(), "The paragraph should be visible")
    }

    func testVisbilityControls() {
        // Selecting 1 (nothing happens - NPS and Paragraph are not visible)
        selectMood(atIndex: 0)
        XCTAssert(!mainScreen.nps.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 2 (nothing happens - NPS and Paragraph are not visible)
        selectMood(atIndex: 1)
        XCTAssert(!mainScreen.nps.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 3 (nothing happens - NPS and Paragraph are not visible)
        selectMood(atIndex: 2)
        XCTAssert(!mainScreen.nps.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 4 (nothing happens - NPS and Paragraph are not visible)
        selectMood(atIndex: 3)
        XCTAssert(!mainScreen.nps.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 5 in Mood Control displays NPS
        selectMood(atIndex: 4)
        XCTAssert(mainScreen.nps.isHittable, "The NPS should be visible")

        // Selecting 5 in NPS displays Paragraph
        selectNPS(withValue: 0.5)
        XCTAssert(paragraph.visible(), "The paragraph should be visible")

        // Selecting 1 (2, 3 or 4) in Mood Control hides NPS and Paragraph
        selectMood(atIndex: 0)
        XCTAssert(!mainScreen.nps.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 2 in Mood Control hides NPS and Paragraph
        displayNPSAndParagraph()
        selectMood(atIndex: 1)
        XCTAssert(!mainScreen.nps.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 3 in Mood Control hides NPS and Paragraph
        displayNPSAndParagraph()
        selectMood(atIndex: 2)
        XCTAssert(!mainScreen.nps.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 4 in Mood Control hides NPS Paragraph
        displayNPSAndParagraph()
        selectMood(atIndex: 3)
        XCTAssert(!mainScreen.nps.isHittable, "The NPS should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 5 in Mood Control displays only NPS and not the Paragraph
        selectMood(atIndex: 4)
        XCTAssert(mainScreen.nps.isHittable, "The NPS should be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")
    }
}
