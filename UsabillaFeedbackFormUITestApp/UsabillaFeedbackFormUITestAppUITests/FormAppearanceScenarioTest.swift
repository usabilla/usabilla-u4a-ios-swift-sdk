//
//  FormAppearanceScenarioTest.swift
//  UsabillaFeedbackFormUITestApp
//
//  Created by Adil Bougamza on 01/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

@testable import UsabillaFeedbackForm

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }

    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}

class FormAppearanceScenarioTest: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testExample() {
        let app = XCUIApplication()
        app.buttons["scenario-1-button"].tap()

        // first cell is mood control
        let firstCell = app.tables.cells.containing(.staticText, identifier: "Click to edit question *").children(matching: .button)
        XCTAssert(firstCell.element.exists, "mood exists")

        let nav = app.navigationBars["UsabillaFeedbackForm.FormView"]

        // cancel button exists
        let cancel = nav.buttons["Cancel"]
        XCTAssert(cancel.exists, "Cancel button should exist")

        // next button exists
        let next = nav.buttons["Next"]
        XCTAssert(next.exists, "Next button should exist")

        // Usabilla logo is present
        let table = app.tables.element(boundBy: 0)
        let lastCell = table.cells.element(boundBy: table.cells.count - 1)
        table.scrollToElement(element: lastCell)
        let poweredByButton = lastCell.buttons["powered-by-id"]
        XCTAssert(poweredByButton.exists, "poweredByButton should exist")
    }
}
