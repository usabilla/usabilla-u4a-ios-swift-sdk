//
//  NPSControlTests.swift
//  UsabillaTests
//
//  Created by Benjamin Grima on 26/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class NPSControlTests: QuickSpec {
    override func spec() {
        var view: NPSControl!

        describe("NPSControl") {
            beforeEach {
                view = NPSControl()
            }

            context("When initialized"){
                it("Should have the correct value by default") {
                    expect(view.rating).to(beNil())
                    expect(view.boldFont).to(beNil())
                    expect(view.font).to(beNil())
                    expect(view.toolTipTextColor).to(beNil())
                    expect(view.accessibilityElementCount()).to(equal(11))
                }
            }

            context("When setting the rating"){
                it("Should set it correctly") {
                    expect(view.rating).to(beNil())
                    view.rating = 0
                    expect(view.rating).to(equal(0))
                    view.rating = 10
                    expect(view.rating).to(equal(10))
                }
                it("Should reset the rating if value is not between 0 and 10") {
                    expect(view.rating).to(beNil())
                    view.rating = -1
                    expect(view.rating).to(beNil())
                    view.rating = 11
                    expect(view.rating).to(beNil())
                }
            }

            context("When incrementing with accessibility"){
                it("Should increment the vallue") {
                    expect(view.rating).to(beNil())
                    view.accessibilityIncrement()
                    expect(view.rating).to(equal(0))
                    view.accessibilityIncrement()
                    expect(view.rating).to(equal(1))
                }
                it("Should not go above 10") {
                    view.rating = 9
                    view.accessibilityIncrement()
                    expect(view.rating).to(equal(10))
                    view.accessibilityIncrement()
                    expect(view.rating).to(equal(10))
                }
            }

            context("When decrementing with accessibility"){
                it("Should increment the vallue") {
                    view.rating = 10
                    view.accessibilityDecrement()
                    expect(view.rating).to(equal(9))
                }
                it("Should not go below 0") {
                    view.rating = 1
                    view.accessibilityDecrement()
                    expect(view.rating).to(equal(0))
                    view.accessibilityDecrement()
                    expect(view.rating).to(equal(0))
                }
            }
        }
    }
}
