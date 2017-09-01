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

    var formStore: FormStore!
    var formService: FormServiceProtocol!

    override func spec() {

        beforeSuite {
            self.formService = FormService()
            self.formStore = FormStore(service: self.formService)
        }

        describe("FormStoreTests") {

            context("When calling loadStore", {
                it("Should succeed and return formModel from network if formID isValid", closure: {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formStore.loadForm(id: "583c0d8ea935028022c145f4", screenshot: nil, theme: UsabillaTheme())
                        promise.then { formMdel in
                            expect(formMdel.identifier).to(equal("583c0d8ea935028022c145f4"))
                            expect(formMdel.formJsonString).toNot(beNil())
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                })
                it("Should succeed and return cached formModel if it's cached", closure: {
                    let mockFormModel = UBMock.formMock()
                    let isCached = UBFormDAO.shared.create(mockFormModel)
                    expect(isCached).to(beTrue())

                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formStore.loadForm(id: mockFormModel.identifier, screenshot: nil, theme: UsabillaTheme())
                        promise.then { cachedFormModel in
                            expect(cachedFormModel.identifier).to(equal(mockFormModel.identifier))
                            expect(cachedFormModel.formJsonString).toNot(beNil())
                            done()
                        }.catch { _ in
                            fail()
                        }
                    }
                })
                it("Should fail if nothing is retrieved form network nor found in cache", closure: {
                    waitUntil(timeout: 2.0) { done in
                        let promise = self.formStore.loadForm(id: "NonExistingFormId", screenshot: nil, theme: UsabillaTheme())
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
                    let defaultFrom = self.formStore.loadForm(id: "", screenshot: nil, theme: UsabillaTheme())
                    expect(defaultFrom).toNot(beNil())
                })
            })
        }
    }
}
