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

    private func selectSlider(withValue value: CGFloat) {
        app.sliders.element(boundBy: 0).adjust(toNormalizedSliderValue: value)
    }

    private func displaySliderAndParagraph() {
        selectMood(atIndex: 4)
        selectSlider(withValue: 0.5)
        XCTAssert(app.sliders.count == 1, "The slider should be visible")
        XCTAssert(paragraph.visible(), "The paragraph should be visible")
    }

    func testVisbilityControls() {
        // Selecting 1 (nothing happens - Slider and Paragraph are not visible)
        selectMood(atIndex: 0)
        XCTAssert(app.sliders.count == 0, "The slider should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 2 (nothing happens - Slider and Paragraph are not visible)
        selectMood(atIndex: 1)
        XCTAssert(app.sliders.count == 0, "The slider should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 3 (nothing happens - Slider and Paragraph are not visible)
        selectMood(atIndex: 2)
        XCTAssert(app.sliders.count == 0, "The slider should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 4 (nothing happens - Slider and Paragraph are not visible)
        selectMood(atIndex: 3)
        XCTAssert(app.sliders.count == 0, "The slider should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 5 in Mood Control displays Slider
        selectMood(atIndex: 4)
        XCTAssert(app.sliders.count == 1, "The slider should be visible")

        // Selecting 5 in Slider displays Paragraph
        selectSlider(withValue: 0.5)
        XCTAssert(paragraph.visible(), "The paragraph should be visible")

        // Selecting 1 (2, 3 or 4) in Mood Control hides Slider and Paragraph
        selectMood(atIndex: 0)
        XCTAssert(app.sliders.count == 0, "The slider should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 2 in Mood Control hides Slider and Paragraph
        displaySliderAndParagraph()
        selectMood(atIndex: 1)
        XCTAssert(app.sliders.count == 0, "The slider should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 3 in Mood Control hides Slider and Paragraph
        displaySliderAndParagraph()
        selectMood(atIndex: 2)
        XCTAssert(app.sliders.count == 0, "The slider should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 4 in Mood Control hides Slider and Paragraph
        displaySliderAndParagraph()
        selectMood(atIndex: 3)
        XCTAssert(app.sliders.count == 0, "The slider should not be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")

        // Selecting 5 in Mood Control displays only Slider and not the Paragraph
        selectMood(atIndex: 4)
        XCTAssert(app.sliders.count == 1, "The slider should be visible")
        XCTAssert(!paragraph.visible(), "The paragraph should not be visible")
    }
}
