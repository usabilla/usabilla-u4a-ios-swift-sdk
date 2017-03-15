//
//  NetworkManagerTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 17/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//


import Quick
import Nimble

@testable import UsabillaFeedbackForm

class NetworkManagerTest: QuickSpec {
    override func spec() {
        describe("NetworkManager") {

            context("When Submitting a form", {
                it("should succeed without a screenshot") {
                    waitUntil(timeout: 2.0) { done in
                        let payload = ["data": []]
                        let promise = NetworkManager.submitFormToUsabilla(payload: payload, screenshot: nil)
                        promise.then { _ in
                            done()
                            }.catch { _ in
                                fail("should not go here")
                        }
                    }
                }
                it("should succeed with a screenshot") {
                    waitUntil(timeout: 2.0) { done in
                        let payload = ["data": []]
                        let screenshot = Icons.imageOfPoweredBy(color: .blue).toBase64()
                        let promise = NetworkManager.submitFormToUsabilla(payload: payload, screenshot: screenshot)
                        promise.then { _ in
                            done()
                            }.catch { _ in
                                fail("should not go here")
                        }
                    }
                }
                it("should fail with an empty payload and screenshot") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = NetworkManager.submitFormToUsabilla(payload: [:], screenshot: "")
                        promise.then { _ in
                            fail("should not go here")
                            
                            }.catch { _ in
                                done()
                                
                        }
                    }
                }
            })
            
            context("When calling getFormJsonFromServer ", {
                it("should fail with invalid formId") {
                    NetworkManager.getFormJsonFromServer("thisIsNotAValidFormId", screenshot: nil, customVariables: nil, themeConfig: UsabillaThemeConfigurator())
                }
                
                it("NetworkManager getForm should fail") {
                    NetworkManager.getFormJsonFromServer("583c0d8ea935028022c145f4", screenshot: nil, customVariables: nil, themeConfig: UsabillaThemeConfigurator())
                }
            })
            
            context("When calling getFormWithFormID", {
                it("should fail with an invalid formId") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = NetworkManager.getFormWithFormID(formID: "thisIsNotAValidFormId")
                        promise.then { _ in
                            fail("should not go here")
                            }.catch { _ in
                                done()
                        }
                    }
                }
                it("should succeed with a valid formId") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = NetworkManager.getFormWithFormID(formID: "583c0d8ea935028022c145f4")
                        promise.then { _ in
                            done()
                            }.catch { _ in
                                fail("should not go here")
                        }
                    }
                }
            })
            
            context("when calling submitFeedbackSmallData", {
                it("should fail when using wrong payload") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = NetworkManager.submitFeedbackSmallData(payload: [:])
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
                        let promise = NetworkManager.submitFeedbackSmallData(payload: payload)
                        promise.then { _ in
                            done()
                            }.catch { _ in
                                fail("should not go here")
                        }
                    }
                }
            })
            
            context("When calling loadDefaultForm", {
                it("should return the default form successfully") {
                    let nc = NetworkManager.loadDefaultForm("", screenshot: nil, customVariables: nil, themeConfig: UsabillaThemeConfigurator())
                    expect(nc).toNot(beNil())
                }
            })
            
            context("When getFormJson is called", { 
                it("should fail getting formModel when formId is wrong") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = NetworkManager.getForm("ThisIsAnInvalidFormId", screenshot: nil, customVariables: nil, themeConfig: UsabillaThemeConfigurator())
                        promise.then(execute: { _ in
                            fail()
                        }).catch(execute: { _ in
                            done()
                        })
                    }
                }
                it("should retun a formModel when appid is correct") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = NetworkManager.getForm("58bd668e4ee2f5fc304eac59", screenshot: nil, customVariables: nil, themeConfig: UsabillaThemeConfigurator())
                        promise.then(execute: { _ in
                            done()
                        }).catch(execute: { _ in
                            fail()
                        })
                    }
                }
            })
            
        }
    }
}
