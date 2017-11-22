//
//  13_CampaignPageToastNoControls.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 31/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class CampaignPageToastNoControls: UBXCScenario {

    let banner = Banner()
    let modal = Modal()
    let toast = Toast()

    override func setUp() {
        super.setUp(type: .campaignForm, scenario: "13_CampaignPageToastNoControls")
    }

    func testPageAndToastAreDisplayed() {
        banner.continueButton.tap()
        XCTAssert(modal.form.element.exists)
        XCTAssert(modal.form.navigationBar.element.exists)
        XCTAssert(modal.form.navigationBar.cancelButton.exists)
        XCTAssert(modal.form.navigationBar.submitButton.exists)

        modal.form.navigationBar.submitButton.tap()
        XCTAssert(toast.element.exists)
        XCTAssert(toast.text == nil || toast.text! == "")
    }
}

