//
//  11_BannerNPSJumpRulesGoesToPagesAndToasts.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 25/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class BannerNPSJumpRulesGoesToPagesAndToasts: XCTestCase {

    let app = XCUIApplication()
    let npsComponent = BannerView.nps

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.setup(type: .campaignForm, scenario: "11_BannerNPSJumpRulesGoesToPagesAndToasts")
        app.launch()
    }

    private func getTextViewText() -> String {
        let textView = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .textView).element
        return textView.value as! String
    }

    func testNPS0GoestToPage2() {
        BannerView.selectNPS(withValue: 0)
        XCTAssert(getTextViewText() == "Page 2", "It should display 'Page 2'")
    }

    func testNPS1GoestToPage3() {
        BannerView.selectNPS(withValue: 0.2)
        XCTAssert(getTextViewText() == "Page 3", "It should display 'Page 2'")
    }

    func testNPS2GoestToToast1() {
        BannerView.selectNPS(withValue: 0.25)
        XCTAssert(app.staticTexts["Toast 1"].exists, "It should display the end page")
    }

    func testNPS3GoestToToast2() {
        BannerView.selectNPS(withValue: 0.35)
        XCTAssert(app.staticTexts["Thanks!"].exists, "It should display the end page")
    }

    func testNPS4GoestToToast2() {
        BannerView.selectNPS(withValue: 0.45)
        XCTAssert(app.staticTexts["Thanks!"].exists, "It should display the end page")
    }

    func testNPS5GoestToToast2() {
        BannerView.selectNPS(withValue: 0.5)
        XCTAssert(app.staticTexts["Thanks!"].exists, "It should display the end page")
    }

    func testNPS6GoestToToast2() {
        BannerView.selectNPS(withValue: 0.6)
        XCTAssert(app.staticTexts["Thanks!"].exists, "It should display the end page")
    }

    func testNPS7GoestToToast2() {
        BannerView.selectNPS(withValue: 0.67)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 2'")
    }

    func testNPS8GoestToToast2() {
        BannerView.selectNPS(withValue: 0.77)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 2'")
    }

    func testNPS9GoestToToast2() {
        BannerView.selectNPS(withValue: 0.85)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 2'")
    }

    func testNPS10GoestToToast2() {
        BannerView.selectNPS(withValue: 0.95)
        XCTAssert(getTextViewText() == "Page 1", "It should display 'Page 2'")
    }
}
