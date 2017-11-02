//
//  14_BannerNoControlNoButtons.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 02/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerNoControlNoButtons: UBXCScenario {
    
    let banner = Banner()
    override func setUp() {
        super.setUp(type: .campaignForm, scenario: "14_BannerNoControlNoButtons")
    }
    
    func testBannerIsDisplayed() {
        XCTAssert(banner.element.exists)
        XCTAssert(!banner.cancelButton.exists)
        XCTAssert(!banner.continueButton.exists)
    }
}
