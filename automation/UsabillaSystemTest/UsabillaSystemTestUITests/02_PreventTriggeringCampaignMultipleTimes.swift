//
//  02_PreventTriggeringCampaignMultipleTimes.swift
//  UsabillaIntegrationTestUITests
//
//  Created by Jack on 21/12/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class PreventTriggeringCampaignMultipleTimes: XCTestCase {

    let app = XCUIApplication()


    override func setUp() {
        super.setUp()
        app.launchArguments += ["-AppleLanguages", "(nl)"]
        app.launchArguments += ["-AppleLocale", "nl_NL"]
        continueAfterFailure = false
        app.launch()
    }

    func testCampaignAppearance() {
        app.buttons["reset"].tap()

        app.textFields["eventInput"].tap()
        app.textFields["eventInput"].typeText("once")
        app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 10, dy: 10)).tap()
        let sendButton = app.buttons["send"]
        sendButton.tap()
        sleep(2)
        
        let ratingcontrolElement = app.otherElements["ratingControl"]
        XCTAssert(ratingcontrolElement.exists, "rating control banner exists")

        let cancelButton = app.buttons["Cancel"]
        cancelButton.tap()

        sendButton.tap()
        sleep(2)
        
        let banner = app.otherElements["ratingControl"]
        XCTAssert(!banner.exists, "rating control banner is not shown")
    }
}
