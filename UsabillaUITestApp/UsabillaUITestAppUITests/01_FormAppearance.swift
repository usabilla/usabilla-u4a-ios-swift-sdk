//
//  01_FormAppearance.swift
//  UsabillaUITestApp
//
//  Created by Adil Bougamza on 01/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

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

class FormAppearance: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.setup(type: .passiveForm, scenario: "01_FormAppearance")
        app.launch()
    }

    func testOneField() {
        // first cell is mood control
        let firstCell = app.tables.children(matching: .cell).element(boundBy: 0)
        let cellContent = firstCell.children(matching: .button)
        XCTAssert(cellContent.count == 5, "5 buttons are presents")

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
            navigationTitle =  feedbackNavigationBar.otherElements["Feedback"]
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
