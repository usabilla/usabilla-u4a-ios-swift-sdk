//
//  UsabillaIntegrationTestUITests.swift
//  UsabillaIntegrationTestUITests
//
//  Created by Benjamin Grima on 27/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class UsabillaIntegrationTestUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(nl)"]
        app.launchArguments += ["-AppleLocale", "nl_NL"]
        continueAfterFailure = false
        app.launch()
    }

    func testExample() {
        let app = XCUIApplication()
        app.buttons["reset"].tap()

        let sendButton = app.buttons["send"]
        sendButton.tap()
        sendButton.tap()

        let ratingcontrolElement = app.otherElements["ratingControl"]
        XCTAssert(ratingcontrolElement.exists, "rating control banner exists")
    }
}
