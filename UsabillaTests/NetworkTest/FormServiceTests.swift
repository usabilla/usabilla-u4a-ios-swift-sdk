//
//  FormServiceTests.swift
//  Usabilla
//
//  Created by Adil Bougamza on 31/05/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

class FormServiceTests: QuickSpec {

    var formService = FormService()

    override func spec() {
        describe("FormService") {
            context("When Submitting a form") {
                it("should succeed without a screenshot") {
                    waitUntil(timeout: 2.0) { done in
                        let payload = ["data": []]
                        let promise = self.formService.submitForm(payload: payload, screenshot: nil)
                        promise.then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should succeed with a screenshot") {
                    waitUntil(timeout: 3.0) { done in
                        let payload = ["data": []]
                        let screenshot = Icons.imageOfPoweredBy(color: .blue).toBase64()
                        let promise = self.formService.submitForm(payload: payload, screenshot: screenshot)
                        promise.then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail with an empty payload and screenshot") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.submitForm(payload: [:], screenshot: "")
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }

            context("When calling getFormWithFormID", {
                it("should succeed with a valid formID") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "583c0d8ea935028022c145f4", screenShot: nil)
                        promise.then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail with an invalid formID") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "thisIsNotAValidFormId", screenShot: nil)
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail when formid param contains {") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "583c0d8ea935028{022c145f4", screenShot: nil)
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail when formid param contains \\") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "583c0d8ea935028\\022c145f4", screenShot: nil)
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail when formid param contains :") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "583c0d8:ea935028022c145f4", screenShot: nil)
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail when formid param contains }") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "583c0d8ea935028022c}145f4", screenShot: nil)
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail when form json is not valid") {
                    let validFormData = try! UBMock.json("InvalidFormJsonNoPages")?.rawData()
                    UBHTTPMock.response = HTTPClientResponse(data: validFormData, headers: nil, error: nil, success: true, isChanged: true)
                    waitUntil(timeout: 2.0) { done in
                        FormService(httpClient: UBHTTPMock.self).getForm(withID: "a", screenShot: nil).then { _ in
                            fail("Should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            })

            context("when calling submitFeedbackSmallData", {
                it("should fail when using wrong payload") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.submitFeedbackSmallData(payload: [:])
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should succeed when passed correct payload") {
                    waitUntil(timeout: 2.0) { done in
                        let payload = ["data": []]
                        let promise = self.formService.submitFeedbackSmallData(payload: payload)
                        promise.then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            })

            context("When getFormJson is called") {
                it("should fail getting formModel when formID is wrong") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "ThisIsAnInvalidFormId", screenShot: nil)
                        promise.then { _ in
                            fail()
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should retun a formModel when appid is correct") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "58bd668e4ee2f5fc304eac59", screenShot: nil)
                        promise.then { _ in
                            done()
                        }.catch { _ in
                            fail()
                        }
                    }
                }
            }
        }
    }
}
