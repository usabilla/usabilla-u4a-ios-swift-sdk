//
//  26_AccessibilityScreenshot.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 01/03/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import XCTest

class AccessibilityScreenshot: UBXCScenario {

    func testScreenshotButtonsDoNotExist() {
        super.setUp(type: .passiveForm, scenario: "26_AccessibilityScreenshot")
        
        let changeScreenshot = app.tables.buttons["change screenshot"]
        let deleteScreenshot = app.tables.buttons["delete screenshot"]
        XCTAssertFalse(changeScreenshot.exists)
        XCTAssertFalse(deleteScreenshot.exists)

    }

    func testScreenshotButtonsExist() {
        super.setUp(type: .passiveForm, scenario: "26_AccessibilityScreenshot", withScreenshot: true)
        
        let changeScreenshot = app.tables.buttons["change screenshot"]
        let deleteScreenshot = app.tables.buttons["delete screenshot"]
        XCTAssert(changeScreenshot.exists)
        XCTAssert(deleteScreenshot.exists)
    }
}
