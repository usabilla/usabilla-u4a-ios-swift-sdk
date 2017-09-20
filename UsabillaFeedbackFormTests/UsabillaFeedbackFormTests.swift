//
//  UsabillaFeedbackFormTests.swift
//  UsabillaFeedbackFormTests
//
//  Created by Giacomo Pinato on 02/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UsabillaFeedbackFormTest: QuickSpec, UsabillaFeedbackFormDelegate {

    private var succeed: (() -> Void)?
    private var failed: (() -> Void)?

    override func spec() {

        describe("UsabillaFeedbackFormTest") {

            beforeEach {
                UsabillaFeedbackForm.delegate = self
            }

            it("UsabillaFeedbackFormTest localizable") {
                expect(UsabillaFeedbackForm.defaultLocalisationFile).to(beTrue())
                UsabillaFeedbackForm.localizedStringFile = "test"
                expect(UsabillaFeedbackForm.defaultLocalisationFile).to(beFalse())
            }

            it("UsabillaFeedbackFormTest takescreenshot") {
                let powered = Icons.imageOfPoweredBy(color: .blue)
                let imageView = UIImageView(image: powered)
                let screenshot = UsabillaFeedbackForm.takeScreenshot(imageView)
                expect(screenshot).toNot(beNil())
                expect(screenshot?.size).to(equal(powered.size))
            }

            it("UsabillaFeedbackFormTest loadFeedbackForm shoud succeed") {
                waitUntil(timeout: 5.0) { done in
                    self.succeed = {
                        done()
                    }
                    self.failed = {
                        fail()
                    }
                    UsabillaFeedbackForm.loadFeedbackForm("588616eca935029b15d51a51")
                }
            }

            context("when loading the sdk") {
                it("should be initialized with the correct appID") {
                    UsabillaFeedbackForm.initialize(appID: "")
                    expect(UsabillaFeedbackForm.appID).to(beNil())
                }

                it("should be initialized with no appID when it is not a UUID") {
                    UsabillaFeedbackForm.initialize(appID: "0D5424BE-41AD-4434-A081-32C393A998A3")
                    expect(UsabillaFeedbackForm.appID).to(equal("0D5424BE-41AD-4434-A081-32C393A998A3"))
                }
                it("should call the fail delegate method if the form cannot be loaded") {
                    waitUntil(timeout: 55.0) { done in
                        self.succeed = {
                            fail()
                        }
                        self.failed = {
                            done()
                        }
                        UsabillaFeedbackForm.loadFeedbackForm("588616eca935aab15d51a51")
                    }
                }
            }

            context("When Active statuses are set") {
                it("it should update the activeStatuses dictionary with right values") {
                    expect(UsabillaFeedbackForm.customVariables).toNot(beNil())
                    
                    UsabillaFeedbackForm.customVariables = ["key1": "value1"]
                    expect(UsabillaFeedbackForm.customVariables["key1"]).toNot(beNil())
                    let value = UsabillaFeedbackForm.customVariables["key1"] as? String
                    expect(value).to(equal("value1"))
                    
                    UsabillaFeedbackForm.setCustomVariable(value: "value2", forKey: "key2")
                    expect(UsabillaFeedbackForm.customVariables.keys.count).to(equal(2))
                    
                    UsabillaFeedbackForm.setCustomVariable(value: nil, forKey: "key2")
                    expect(UsabillaFeedbackForm.customVariables.keys.count).to(equal(1))
                }
            }

            context("When custom variables are set") {
                it("it should accept valid custom variables") {
                    UsabillaFeedbackForm.customVariables = [:]

                    expect(UsabillaFeedbackForm.customVariables).toNot(beNil())
                    expect(UsabillaFeedbackForm.customVariables).to(beEmpty())

                    var cs: [String: Any] = [:]
                    cs["string"] = "1"
                    cs["int"] = 1
                    cs["array"] = [1,2,3,4]

                    UsabillaFeedbackForm.customVariables = cs

                    expect(UsabillaFeedbackForm.customVariables).toNot(beEmpty())
                    expect(UsabillaFeedbackForm.customVariables["array"] as! [Int]).to(equal([1,2,3,4]))
                    expect(UsabillaFeedbackForm.customVariables["int"] as! Int).to(equal(1))
                }

                it("it should refuse invalid custom variables") {
                    UsabillaFeedbackForm.customVariables = [:]

                    expect(UsabillaFeedbackForm.customVariables).toNot(beNil())
                    expect(UsabillaFeedbackForm.customVariables).to(beEmpty())
                    UsabillaFeedbackForm.customVariables["wrong"] = UIColor.red
                    expect(UsabillaFeedbackForm.customVariables).to(beEmpty())
                    UsabillaFeedbackForm.customVariables["wrong"] = UBMock.campaignMock()
                    expect(UsabillaFeedbackForm.customVariables).to(beEmpty())

                }
            }
        }
    }

    func formFailedLoading() {
        failed?()
    }

    func formLoadedCorrectly(_ form: UINavigationController) {
        succeed?()
    }
}
