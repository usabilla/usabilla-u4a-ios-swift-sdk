//
//  UsabillaIntegrationTestUITests.swift
//  UsabillaIntegrationTestUITests
//
//  Created by Benjamin Grima on 27/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class TriggerAndDisplayCampaign: XCTestCase {

    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(nl)"]
        app.launchArguments += ["-AppleLocale", "nl_NL"]
        continueAfterFailure = false
        app.launch()
    }

    func testCampaignAppearance() {
        let app = XCUIApplication()
        app.buttons["reset"].tap()

        app.textFields["eventInput"].tap()
        app.textFields["eventInput"].typeText("purchaseComplete")
        app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 10, dy: 10)).tap()

        let sendButton = app.buttons["send"]
        sendButton.tap()
        sendButton.tap()

        let ratingcontrolElement = app.otherElements["ratingControl"]
        XCTAssert(ratingcontrolElement.exists, "rating control banner exists")
    }
}
