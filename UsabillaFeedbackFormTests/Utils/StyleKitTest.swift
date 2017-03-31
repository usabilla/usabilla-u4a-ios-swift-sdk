//
//  StyleKitTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//


import Quick
import Nimble

@testable import UsabillaFeedbackForm

class StyleKitTest: QuickSpec {

    override func spec() {

        describe("StyleKit") {
            it("StyleKit icons imageOfEdit") {
                let a = Icons.imageOfEdit(color: .white)
                let b = Icons.imageOfEdit(color: .white) // second time for the cache

                expect(a).to(equal(b))
            }

            it("StyleKit icons imageOfEdit") {
                let a = Icons.imageOfAddImage(color: .white)
                let b = Icons.imageOfAddImage(color: .white) // second time for the cache

                expect(a).to(equal(b))
            }

            it("StyleKit icons imageOfEdit") {
                let a = Icons.imageOfArtboard(color: .white)
                let b = Icons.imageOfArtboard(color: .white) // second time for the cache

                expect(a).to(equal(b))
            }
            it("StyleKit icons imageOfEdit") {
                let a = Icons.imageOfPoweredBy(color: .white)
                let b = Icons.imageOfPoweredBy(color: .white) // second time for the cache

                expect(a).to(equal(b))
            }
        }
    }
}
