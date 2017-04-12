//
//  FormStoreTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class FormStoreTests: QuickSpec {

    override func spec() {

        describe("FormStoreTests") {

            context("When calling loadStore", {
                it("Should succeed and return formModel from network if formId isValid", closure: {
                    waitUntil(timeout: 2.0) { done in
                        let promise = FormStore.loadForm(id: "583c0d8ea935028022c145f4", screenshot: nil, customVariables: [:], theme: UsabillaTheme())
                        promise.then { formMdel in
                            expect(formMdel.appId).to(equal("583c0d8ea935028022c145f4"))
                            expect(formMdel.formJsonString).toNot(beNil())
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                })
                it("Should succeed and return cached formModel if it's cached", closure: {
                    let mockFormModel = UBMock.formMock()
                    CacheManager.shared.cacheForm(id: mockFormModel.appId, form: mockFormModel)

                    waitUntil(timeout: 2.0) { done in
                        let promise = FormStore.loadForm(id: mockFormModel.appId, screenshot: nil, customVariables: [:], theme: UsabillaTheme())
                        promise.then { cachedFormModel in
                            expect(cachedFormModel.appId).to(equal(mockFormModel.appId))
                            expect(cachedFormModel.formJsonString).toNot(beNil())
                            done()
                        }.catch { _ in
                            fail()
                        }
                    }
                })
                it("Should fail if nothing is retrieved form network nor found in cache", closure: {
                    waitUntil(timeout: 2.0) { done in
                        let promise = FormStore.loadForm(id: "NonExistingFormId", screenshot: nil, customVariables: [:], theme: UsabillaTheme())
                        promise.then { _ in
                            fail()
                        }.catch { _ in
                            done()
                        }
                    }
                })
            })

            context("When loading the defaultForm", {
                it("should return a default form successfully", closure: {
                    let defaultFrom = FormStore.loadDefaultForm("", screenshot: nil, customVariables: [:], theme: UsabillaTheme())
                    expect(defaultFrom).toNot(beNil())
                })
            })
        }
    }
}