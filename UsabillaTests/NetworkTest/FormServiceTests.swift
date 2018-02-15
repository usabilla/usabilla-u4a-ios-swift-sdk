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

    var formService = FormService(requestBuilder: RequestBuilder.self, httpClient: UBHTTPMock.self)
    override func spec() {
        describe("FormService") {
            context("When Submitting a form") {
                it("should succeed without a screenshot") {
                    waitUntil(timeout: 2.0) { done in
                        let payload = ["data": []]
                        UBHTTPMock.onStringRequest[RequestBuilder.submitUrl] = HTTPClientResponse(data: Data(), headers: nil, error: nil, success: true, isChanged: true)
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
                        UBHTTPMock.onURLRequest[RequestBuilder.submitUrl] = HTTPClientResponse(data: Data(), headers: nil, error: nil, success: true, isChanged: true)
                        UBHTTPMock.onStringRequest[RequestBuilder.submitUrl] = HTTPClientResponse(data: Data(), headers: nil, error: nil, success: true, isChanged: true)
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
                        UBHTTPMock.onStringRequest[RequestBuilder.submitUrl] = HTTPClientResponse(data: Data(), headers: nil, error: NSError.init(domain: "", code: 0, userInfo: nil), success: false, isChanged: true)
                        let promise = self.formService.submitForm(payload: [:], screenshot: "")

                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }

            context("When calling getFormWithFormID") {
                it("should succeed with a valid formID") {
                    waitUntil(timeout: 2.0) { done in
                        let data = UBMock.formMock().formJsonString.rawString()?.data(using: String.Encoding.utf8)
                        let id = "583c0d8ea935028022c145f4"
                        let response = HTTPClientResponse(data: data, headers: nil, error: nil, success: true, isChanged: true)
                        UBHTTPMock.onURLRequest[RequestBuilder.requestGetPassiveForm(withID: id)!.url!.absoluteString] = response

                        let promise = self.formService.getForm(withID: id, screenShot: nil)
                        promise.then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail with an invalid formID") {
                    let id = "thisIsNotAValidFormId"
                    let response404 = HTTPClientResponse(data: nil, headers: nil, error: NSError.init(domain: "404", code: 404, userInfo: nil), success: false, isChanged: true)
                    UBHTTPMock.onURLRequest[RequestBuilder.requestGetPassiveForm(withID: id)!.url!.absoluteString] = response404
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: id, screenShot: nil)
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
                        }.catch { error in
                            expect((error as NSError).domain).to(equal("not a valid url parameter"))
                            done()
                        }
                    }
                }
                it("should fail when formid param contains \\") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "583c0d8ea935028\\022c145f4", screenShot: nil)
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { error in
                            expect((error as NSError).domain).to(equal("not a valid url parameter"))
                            done()
                        }
                    }
                }
                it("should fail when formid param contains }") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formService.getForm(withID: "583c0d8ea935028022c}145f4", screenShot: nil)
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { error in
                            expect((error as NSError).domain).to(equal("not a valid url parameter"))
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
                        }.catch { error in
                            expect((error as NSError).domain).to(equal("form model is not valid"))
                            done()
                        }
                    }
                }
            }

            context("when calling submitFeedbackSmallData") {
                it("should fail when using wrong payload") {
                    waitUntil(timeout: 2.0) { done in
                        UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: NSError.init(domain: "", code: 0, userInfo: nil), success: false, isChanged: true)
                        let promise = self.formService.submitFeedbackSmallData(payload: [:])
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should succeed when passed correct payload") {
                    UBHTTPMock.onStringRequest[RequestBuilder.submitUrl] = HTTPClientResponse(data: Data(), headers: nil, error: nil, success: true, isChanged: true)
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
            }
        }
    }
}
