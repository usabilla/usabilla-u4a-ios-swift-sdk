//
//  UIColorTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UIColorTest: QuickSpec {

    override func spec() {
        let white = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

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
                    let color = try UIColor(rgba_throws: "#FFF")
                    expect(color.isEqual(white)).to(beTrue())
                } catch {
                    fail()
                }
            }

            it("UIColor init should succeed") {
                do {
                    let color = try UIColor(rgba_throws: "#FFFF")
                    expect(color.isEqual(white)).to(beTrue())
                } catch {
                    fail()
                }
            }

            it("UIColor init should succeed") {
                do {
                    let color = try UIColor(rgba_throws: "#FFFFFF")
                    expect(color.isEqual(white)).to(beTrue())
                } catch {
                    fail()
                }
            }

            it("UIColor init should succeed") {
                do {
                    let color = try UIColor(rgba_throws: "#FFFFFFFF")
                    expect(color.isEqual(white)).to(beTrue())
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