//
//  11_BannerNPSJumpRulesGoesToPagesAndToasts.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 25/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerNPSJumpRulesGoesToPagesAndToasts: UBXCScenario {

    let bannerView = BannerViewNPS()

    override func setUp() {
        super.setUp(type: .campaignForm, scenario: "11_BannerNPSJumpRulesGoesToPagesAndToasts")
    }

    func testNPS0GoestToPage2() {
        bannerView.nps.select(number: 0)
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testNPS1GoestToPage3() {
        bannerView.nps.select(number: 1)
        XCTAssert(getTextViewText() == "Page 3", "It should display 'Page 3'")
    }

    func testNPS2GoestToToast1() {
        bannerView.nps.select(number: 2)
        XCTAssert(app.staticTexts["Toast 1"].exists, "It should display 'Toast 1'")
    }

    func testNPS3GoestToToast2() {
        bannerView.nps.select(number: 3)
        XCTAssert(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }

    func testNPS4GoestToToast2() {
        bannerView.nps.select(number: 4)
        XCTAssert(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }

    func testNPS5GoestToToast2() {
        bannerView.nps.select(number: 5)
        XCTAssert(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }

    func testNPS6GoestToToast2() {
        bannerView.nps.select(number: 6)
        XCTAssert(app.staticTexts["Toast 2"].exists, "It should display 'Toast 2'")
    }

    func testNPS7GoestToPage1() {
        bannerView.nps.select(number: 7)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testNPS8GoestToPage1() {
        bannerView.nps.select(number: 8)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testNPS9GoestToPage1() {
        bannerView.nps.select(number: 9)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }

    func testNPS10GoestToPage1() {
        bannerView.nps.select(number: 10)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 1'")
    }
}
