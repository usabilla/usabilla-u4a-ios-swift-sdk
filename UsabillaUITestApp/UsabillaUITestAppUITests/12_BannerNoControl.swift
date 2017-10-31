//
//  12_BannerNoControl.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 31/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerNoControl: UBXCScenario {

    let banner = Banner()
    override func setUp() {
        super.setUp(type: .campaignForm, scenario: "12_BannerNoControl")
    }

    func testBannerIsDisplayed() {
        XCTAssert(banner.element.exists)
        XCTAssert(banner.cancelButton.exists)
        XCTAssert(banner.continueButton.exists)
        XCTAssert(!banner.continueButton.isEnabled)
    }
}
