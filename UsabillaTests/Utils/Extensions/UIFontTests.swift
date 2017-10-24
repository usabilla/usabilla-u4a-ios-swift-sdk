//
//  UIFontTests.swift
//  UsabillaTests
//
//  Created by Adil Bougamza on 24/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Usabilla

class UIFontTests: QuickSpec {

    override func spec() {
        describe("UIFont") {
            context("When called") {
                it("should return right font when ") {
                    let fontRegular = UIFont.uSystemFont(ofSize: 17, weight: FontWeight.regular)
                    let fontSemiBold = UIFont.uSystemFont(ofSize: 20, weight: FontWeight.semiBold)
                    if #available(iOS 11, *) {
                        expect(fontRegular.fontName).to(equal("HelveticaNeue"))
                        expect(fontRegular.pointSize).to(equal(17))
                        expect(fontSemiBold.fontName).to(equal("HelveticaNeue-Medium"))
                        expect(fontSemiBold.pointSize).to(equal(20))
                    } else {
                        expect(fontRegular.fontName).to(equal(".SFUIText-Regular"))
                        expect(fontRegular.pointSize).to(equal(17))
                        expect(fontSemiBold.fontName).to(equal(".SFUIDisplay-Semibold"))
                        expect(fontSemiBold.pointSize).to(equal(20))
                    }
                }
            }
        }
    }
}
