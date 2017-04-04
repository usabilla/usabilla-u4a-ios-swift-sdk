//
//  UBEndPageViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 04/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBEndPageViewModelTests: QuickSpec {

    var endPageModel: UBEndPageModel!
    var formModel: FormModel!

    override func spec() {
        describe("UBEndPageViewModelTests") {
            beforeSuite {
                self.formModel = UBMock.formMock()
                self.endPageModel = (self.formModel.pages.last as? UBEndPageModel)!
            }

            context("When initilized") {
                it("should have the correct data") {
                    let viewModel = UBEndPageViewModel(model: self.endPageModel)
                    let headerFieldModel = self.endPageModel.fields.first as? HeaderFieldModel
                    let stringFieldModel = self.endPageModel.fields[1] as? StringFieldModel
                    expect(viewModel.headerText).to(equal(headerFieldModel?.fieldValue))
                    expect(viewModel.thankyouText).to(equal(stringFieldModel?.fieldValue))
                    expect(viewModel.moreFeedbackText).to(equal(self.endPageModel.copy?.moreFeedback))
                    expect(viewModel.appStoreRedirectText).to(equal(self.endPageModel.copy?.appStore))
                    expect(viewModel.canGiveMoreFeedback).to(beFalse())
                    expect(viewModel.canRedirectToAppStore).to(beFalse())
                    expect(viewModel.theme).toNot(beNil())
                }
            }
            // formRating value should be greater Than 3 to be concidered as true
            context("When redirect to app store property coditions are changed", {
                it("Should return correct value", closure: {
                    let viewModel = UBEndPageViewModel(model: self.endPageModel)
                    self.endPageModel.redirectToAppStore = false
                    viewModel.formRating = 4
                    UsabillaFeedbackForm.appStoreId = "test"

                    expect(viewModel.canRedirectToAppStore).to(beFalse())
                })
                it("Should return correct value", closure: {
                    let viewModel = UBEndPageViewModel(model: self.endPageModel)
                    self.endPageModel.redirectToAppStore = true
                    viewModel.formRating = 3
                    UsabillaFeedbackForm.appStoreId = "test"

                    expect(viewModel.canRedirectToAppStore).to(beFalse())
                })
                it("Should return correct value", closure: {
                    let viewModel = UBEndPageViewModel(model: self.endPageModel)
                    self.endPageModel.redirectToAppStore = true
                    viewModel.formRating = 4
                    UsabillaFeedbackForm.appStoreId = nil

                    expect(viewModel.canRedirectToAppStore).to(beFalse())
                })
                it("Should return correct value", closure: {
                    let viewModel = UBEndPageViewModel(model: self.endPageModel)
                    self.endPageModel.redirectToAppStore = true
                    viewModel.formRating = 4
                    UsabillaFeedbackForm.appStoreId = "test"

                    expect(viewModel.canRedirectToAppStore).to(beTrue())
                })
            })
        }
    }
}
