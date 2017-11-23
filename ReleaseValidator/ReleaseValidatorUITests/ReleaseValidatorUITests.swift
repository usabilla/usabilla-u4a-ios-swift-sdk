//
//  ReleaseValidatorUITests.swift
//  ReleaseValidatorUITests
//
//  Created by Benjamin Grima on 23/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class ReleaseValidatorUITests: XCTestCase {
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()

    }

    func testShowForm() {
        XCUIApplication().navigationBars.buttons["Feedback"].tap()
        let navigationBar = XCUIApplication().navigationBars["Feedback"]
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: navigationBar, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
