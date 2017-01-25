//
//  UIColorTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UIColorTest: QuickSpec {

    override func spec() {

        describe("UIColor") {
            it("UIColor init should fail") {
                do {
                    _ = try UIColor(rgba_throws: "FFF")
                    fail()
                } catch {
                    expect(true).to(beTrue())
                }
            }

            it("UIColor init should fail") {
                do {
                    _ = try UIColor(rgba_throws: "#F")
                    fail()
                } catch {
                    expect(true).to(beTrue())
                }
            }

            it("UIColor init should fail") {
                do {
                    _ = try UIColor(rgba_throws: "#KKK")
                    fail()
                } catch {
                    expect(true).to(beTrue())
                }
            }

            it("UIColor init should succeed") {
                do {
                    _ = try UIColor(rgba_throws: "#FFF")
                } catch {
                    fail()
                }
            }

            it("UIColor init should succeed") {
                do {
                    _ = try UIColor(rgba_throws: "#FFFF")
                } catch {
                    fail()
                }
            }

            it("UIColor init should succeed") {
                do {
                    _ = try UIColor(rgba_throws: "#FFFFFF")
                } catch {
                    fail()
                }
            }

            it("UIColor init should succeed") {
                do {
                    _ = try UIColor(rgba_throws: "#FFFFFFFF")
                } catch {
                    fail()
                }
            }

            it("UIColor init should succeed") {
                let color = UIColor(rgba: "#FFF", defaultColor: .black)
                expect(color.hexString(false)).to(equal("#FFFFFF"))
            }

            it("UIColor init should succeed") {
                let color = UIColor(rgba: "aaa", defaultColor: .black)
                expect(color.hexString(false)).to(equal("#000000"))
            }
            
            it("UIColor hexString") {
                let color = UIColor(rgba: "####", defaultColor: .black)
                expect(color.hexString(true)).to(equal("#000000FF"))
            }
            
        }
    }
}
