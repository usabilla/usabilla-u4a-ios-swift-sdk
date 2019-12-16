//
//  03_TestForMultipleCampaignsCrash.swift
//  UsabillaSystemTestUITests
//
//  Created by Anders Liebl on 22/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import XCTest

class TestForMultipleCampaignsCrash: XCTestCase {
    
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
        app.textFields["eventInput"].typeText("triggerExtra")
        app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 10, dy: 10)).tap()
        var sendButton = app.buttons["send"]
        sendButton.tap()
        var ratingcontrolElement = app.otherElements["ratingControl"]        
        
        let cancelButton = app.buttons["Cancel"]
        cancelButton.tap()
        
        app.buttons["reset"].tap()
        
        app.textFields["eventInput"].tap()
        app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 10, dy: 10)).tap()
        sendButton = app.buttons["send"]
        sendButton.tap()
        ratingcontrolElement = app.otherElements["ratingControl"]
        XCTAssert(ratingcontrolElement.exists, "rating control banner does not exists")
        
    }
    
}
