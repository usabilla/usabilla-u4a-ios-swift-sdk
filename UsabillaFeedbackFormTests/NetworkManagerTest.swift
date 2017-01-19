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

            it("NetworkManager submitFormToUsabilla") {
                let payload = ["data": []]
                NetworkManager.submitFormToUsabilla(payload: payload, screenshot: "")
            }
            
            it("NetworkManager submitFormToUsabilla") {
                NetworkManager.submitFormToUsabilla(payload: [:], screenshot: "")
            }

            it("NetworkManager getForm should fail") {
                NetworkManager.getFormJsonFromServer("thisIsNotAValidFormId", screenshot: nil, customVariables: nil, themeConfig: UsabillaThemeConfigurator())
            }
            
            it("NetworkManager getForm should fail") {
                NetworkManager.getFormJsonFromServer("583c0d8ea935028022c145f4", screenshot: nil, customVariables: nil, themeConfig: UsabillaThemeConfigurator())
            }
            
            it("NetworkManager getForm should fail") {
                waitUntil(timeout: 2.0) { done in
                    let promise = NetworkManager.getFormWithFormID(formID: "thisIsNotAValidFormId")
                    promise.then { _ in
                        fail("should not go here")
                    }.catch { _ in
                        done()
                    }
                }
            }

            it("NetworkManager getForm should succeed") {
                waitUntil(timeout: 2.0) { done in
                    let promise = NetworkManager.getFormWithFormID(formID: "583c0d8ea935028022c145f4")
                    promise.then { _ in
                        done()
                    }.catch { _ in
                        fail("should not go here")
                    }
                }
            }
            


            it("NetworkManager submitForm should fail") {
                waitUntil(timeout: 2.0) { done in
                    let promise = NetworkManager.submitFeedbackSmallData(payload: [:])
                    promise.then { _ in
                        fail("should not go here")
                    }.catch { _ in
                        done()
                    }
                }
            }

            it("NetworkManager submitForm should succeed") {
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

            it("NetworkManager load default form") {
                let nc = NetworkManager.loadDefaultForm("", screenshot: nil, customVariables: nil, themeConfig: UsabillaThemeConfigurator())
                expect(nc).toNot(beNil())
            }
        }
    }
}
