//
//  UsabillaFeedbackFormUITestAppUITests.swift
//  UsabillaFeedbackFormUITestAppUITests
//
//  Created by Benjamin Grima on 11/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class UsabillaFeedbackFormUITestAppUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {

        let app = XCUIApplication()
        app.buttons["scenario-1-button"].tap()

        let cells = app.tables.cells
        cells.containing(.staticText, identifier: "Click to edit question *").children(matching: .button).element(boundBy: 0).tap()
        cells.containing(.staticText, identifier: "Click to edit *").children(matching: .textView).element.tap()

        app.typeText("test")

        let nav = app.navigationBars["UsabillaFeedbackForm.FormView"]
        let next = nav.buttons["Next"]
        next.tap()
        next.tap()

        nav.buttons["Submit"].tap()
        nav.buttons["Cancel"].tap()

    }

}
