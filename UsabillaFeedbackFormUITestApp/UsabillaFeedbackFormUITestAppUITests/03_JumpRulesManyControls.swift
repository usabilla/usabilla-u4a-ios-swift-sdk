//
//  03_JumpRulesManyControls.swift
//  UsabillaFeedbackFormUITestApp
//
//  Created by Benjamin Grima on 26/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable force_cast

import XCTest

extension XCUIElement {
    open func adjust(toNormalizedSliderValue normalizedSliderValue: CGFloat) {
        let start = coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
        let end = coordinate(withNormalizedOffset: CGVector(dx: normalizedSliderValue, dy: 0.0))
        start.press(forDuration: 0.05, thenDragTo: end)
    }
}

class JumpRulesManyControls: XCTestCase {

    var app: XCUIApplication!
    var moodButtons: XCUIElementQuery!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["scenario"] = "03_JumpRulesManyControls"
        app.launch()
        moodButtons = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .button)
    }

    private func selectMood(atIndex index: UInt) {
        moodButtons.element(boundBy: index).tap()
    }

    private func selectSlider(withValue value: CGFloat) {
        app.sliders.element(boundBy: 0).adjust(toNormalizedSliderValue: value)
    }

    private func tapNext() {
        app.navigationBars["Feedback"].buttons["Next"].tap()
    }

    private func getTextViewText() -> String {
        let textView = XCUIApplication().tables.children(matching: .cell).element(boundBy: 0).children(matching: .textView).element
        return textView.value as! String
    }

    func testSelecting1InMoodControlAndNoValueForTheSliderTakesToTheNextPage() {
        selectMood(atIndex: 0)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting2InMoodControlAndNoValueForTheSliderTakesToTheNextPage() {
        selectMood(atIndex: 1)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting3InMoodControlAndNoValueForTheSliderTakesToTheNextPage() {
        selectMood(atIndex: 2)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting4InMoodControlAndNoValueForTheSliderTakesToTheNextPage() {
        selectMood(atIndex: 3)
        tapNext()
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testSelecting5InMoodControlAndNoValueForTheSliderTakesToPage3() {
        selectMood(atIndex: 4)
        tapNext()
        XCTAssert(getTextViewText() == "Page 3", "It should display 'Page 3'")
    }

    func testSelecting1InMoodControlAnd4ForTheSliderTakesToPage4() {
        selectMood(atIndex: 0)
        selectSlider(withValue: 0.4)
        tapNext()
        XCTAssert(getTextViewText() == "Page 4", "It should display 'Page 4'")
    }

    func testSelecting5InMoodControlAnd4ForTheSliderTakesToPage3() {
        selectMood(atIndex: 4)
        selectSlider(withValue: 0.4)
        tapNext()
        XCTAssert(getTextViewText() == "Page 3", "It should display 'Page 3'")
    }
}
