//
//  01_FormAppearance.swift
//  UsabillaUITestApp
//
//  Created by Adil Bougamza on 01/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class FormAppearance: UBXCScenario {

    var moodComponent: MoodComponentPassive? = nil

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "01_FormAppearance")
    }

    func testOneField() {

        // Check if mood control exists
        moodComponent = MoodComponentPassive()
        XCTAssertTrue(moodComponent != nil, "element exists")
        XCTAssertTrue((moodComponent!.mood?.isHittable)!, "hittable")
        XCTAssertTrue((moodComponent!.mood?.exists)!, "element exists")

        let feedbackNavigationBar = app.navigationBars["Feedback"]

        // cancel button exists
        let cancel = feedbackNavigationBar.buttons["Cancel"]
        XCTAssert(cancel.exists, "Cancel button should exist")

        // next button exists
        let next = feedbackNavigationBar.buttons["Next"]
        XCTAssert(next.exists, "Next button should exist")

        // form title exists
        var navigationTitle = feedbackNavigationBar.staticTexts["Feedback"]
        if #available(iOS 11.0, *) {
            navigationTitle = feedbackNavigationBar.otherElements["Feedback"]
        }
        XCTAssert(navigationTitle.exists, "Navigation title should exist")

        // Usabilla logo is present
        let table = app.tables.element(boundBy: 0)
        let lastCell = table.cells.element(boundBy: table.cells.count - 1)
        table.scrollToElement(element: lastCell)
        let poweredByButton = lastCell.buttons["powered-by-id"]
        XCTAssert(poweredByButton.exists, "poweredByButton should exist")
    }
}
