//
//  UsabillaInternalTest.swift
//  UsabillaTests
//
//  Created by Giacomo Pinato on 02/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Quick
import Nimble
import UIKit

@testable import Usabilla

class UsabillaInternalTest: QuickSpec, UsabillaDelegate {

    private var succeed: (() -> Void)?
    private var failed: (() -> Void)?

    override func spec() {

        describe("UsabillaInternal") {

            beforeSuite {
                Usabilla.initialize(appID: nil)
            }

            beforeEach {
                Usabilla.delegate = self
            }

            it("UsabillaInternal localizable") {
                expect(UsabillaInternal.defaultLocalisationFile).to(beTrue())
                Usabilla.localizedStringFile = "test"
                expect(UsabillaInternal.defaultLocalisationFile).to(beFalse())
            }

            it("UsabillaInternal takescreenshot") {
                let powered = Icons.imageOfPoweredBy(color: .blue)
                let imageView = UIImageView(image: powered)
                let screenshot = Usabilla.takeScreenshot(imageView)
                expect(screenshot).toNot(beNil())
                expect(screenshot?.size).to(equal(powered.size))
            }
            
            it("UsabillaInternal orientation") {
                let orientation: UIInterfaceOrientationMask = .landscapeRight
                expect(UsabillaInternal.supportedOrientations == UIInterfaceOrientationMask.all).to(beTrue())
                UsabillaInternal.supportedOrientations = orientation
                expect(UsabillaInternal.supportedOrientations == UIInterfaceOrientationMask.all).to(beFalse())
            }
            
            it("UsabillaInternal loadFeedbackForm shoud succeed") {
                waitUntil(timeout: DispatchTimeInterval.seconds(5)) { done in
                    self.succeed = {
                        done()
                    }
                    self.failed = {
                        fail()
                    }
                    Usabilla.loadFeedbackForm("588616eca935029b15d51a51")
                }
            }

            context("when loading the sdk") {
                it("should be initialized with the correct appID") {
                    Usabilla.initialize(appID: "")
                    expect(UsabillaInternal.appID).to(beNil())
                }

                it("should be initialized with no appID when it is not a UUID") {
                    Usabilla.initialize(appID: "0D5424BE-41AD-4434-A081-32C393A998A3")
                    expect(UsabillaInternal.appID).to(equal("0D5424BE-41AD-4434-A081-32C393A998A3"))
                }
                it("should call the fail delegate method if the form cannot be loaded") {
                    waitUntil(timeout: DispatchTimeInterval.seconds(55)) { done in
                        self.succeed = {
                            fail()
                        }
                        self.failed = {
                            done()
                        }
                        Usabilla.loadFeedbackForm("588616eca935aab15d51a51")
                    }
                }
            }

            context("When Active statuses are set") {
                it("it should update the activeStatuses dictionary with right values") {
                    expect(Usabilla.customVariables).toNot(beNil())
                    
                    Usabilla.customVariables = ["key1": "value1"]
                    expect(Usabilla.customVariables["key1"]).toNot(beNil())
                    let value = Usabilla.customVariables["key1"]
                    expect(value).to(equal("value1"))
                    
                    Usabilla.customVariables["key"] = "value2"
                    expect(Usabilla.customVariables.keys.count).to(equal(2))
                    
                    Usabilla.customVariables["key"] = nil
                    expect(Usabilla.customVariables.keys.count).to(equal(1))
                }
            }

            context("When custom variables are set") {
                it("it should accept valid custom variables") {
                    Usabilla.customVariables = [:]

                    expect(Usabilla.customVariables).toNot(beNil())
                    expect(Usabilla.customVariables).to(beEmpty())

                    var cs: [String: String] = [:]
                    cs["string"] = "1"
                    cs["array"] = "[1,2,3,4]"

                    Usabilla.customVariables = cs

                    expect(Usabilla.customVariables).toNot(beEmpty())
                    expect(Usabilla.customVariables["array"] ).to(equal("[1,2,3,4]"))
                    expect(Usabilla.customVariables["string"]).to(equal("1"))
                }

                it("it should refuse invalid custom variables") {
                    Usabilla.customVariables = [:]

                    expect(Usabilla.customVariables).toNot(beNil())
                    expect(Usabilla.customVariables).to(beEmpty())
                    // Not valid as now it only accepts strings
//                    Usabilla.customVariables["wrong"] = UIColor.red
//                    expect(Usabilla.customVariables).to(beEmpty())
//                    Usabilla.customVariables["wrong"] = UBMock.campaignMock()
//                    expect(Usabilla.customVariables).to(beEmpty())

                }
            }
        }
    }

    func formDidFailLoading(error: UBError) {
        failed?()
    }

    func formDidLoad(form: UINavigationController) {
        succeed?()
    }
}
