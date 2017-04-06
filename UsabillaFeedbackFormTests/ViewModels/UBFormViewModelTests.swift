//
//  UBFormViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 04/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBFormViewModelTests: QuickSpec {

    var model: FormModel!
    override func spec() {
        describe("UBFormViewModelTests") {
            beforeSuite {
                self.model = UBMock.formMock()
            }

            context("When initilized with correct model") {
                it("should have correct values") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    expect(formViewModel).toNot(beNil())
                    expect(formViewModel.model).toNot(beNil())
                    expect(formViewModel.currentPageIndex).to(equal(0))
                    expect(formViewModel.currentPageViewModel.name).to(equal("start"))
                    expect(formViewModel.id).to(equal(self.model.appId))
                    expect(formViewModel.shouldHideProgressBar).to(beTrue())
                    expect(formViewModel.progress).to(equal(0.25))
                    expect(formViewModel.accentColor).to(equal(self.model.theme.accentColor))
                    expect(formViewModel.backgrounColor).to(equal(self.model.theme.backgroundColor))
                    expect(formViewModel.statusBarColor).to(equal(self.model.theme.statusBarColor))
                    expect(formViewModel.headerColor).to(equal(self.model.theme.accentColor))
                    expect(formViewModel.textOnAccentColor).to(equal(self.model.theme.textOnAccentColor))
                    expect(formViewModel.cancelButtonTitle).to(beNil())
                    expect(formViewModel.showCancelButton).to(beFalse())
                    expect(formViewModel.isCurrentPageValid).to(beTrue()) // should be false but this needs refactoring isViewCurrentlyVisible
                    expect(formViewModel.firstPageViewModel?.name).to(equal(formViewModel.currentPageViewModel.name))
                    expect(formViewModel.rightBarButtonTitle).to(equal(self.model.copyModel.navigationNext))
                    expect(formViewModel.endPageViewModel).to(beNil())
                    expect(formViewModel.nextPageViewModel!.name).to(equal("Third"))
                    expect(formViewModel.isItTheEnd).to(beFalse())
                }
                it("should have correct values if we change default") {
                    let formViewModel = UBFormViewModel(formModel: self.model)

                    // Change theme header Color
                    self.model.theme.headerColor = .red
                    expect(formViewModel.headerColor).to(equal(UIColor.red))
                    // Chnage showCancelButton to be true
                    UsabillaFeedbackForm.showCancelButton = true
                    expect(formViewModel.showCancelButton).to(beTrue())
                    expect(formViewModel.cancelButtonTitle).to(equal(self.model.copyModel.cancelButton))

                    UsabillaFeedbackForm.showCancelButton = false
                    self.model.theme.headerColor = nil
                }
            }

            context("When going to next pages") {
                it("should have correct data if it's a form page") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    formViewModel.currentPageViewModel = formViewModel.nextPageViewModel!
                    expect(formViewModel.currentPageIndex).to(equal(2))
                    expect(formViewModel.currentPageViewModel.name).to(equal("Third"))
                    expect(formViewModel.shouldHideProgressBar).to(beTrue())
                    expect(formViewModel.progress).to(equal(0.75))
                    expect(formViewModel.cancelButtonTitle).to(beNil())
                    expect(formViewModel.showCancelButton).to(beFalse())
                    expect(formViewModel.isCurrentPageValid).to(beTrue())
                    expect(formViewModel.rightBarButtonTitle).to(equal(self.model.copyModel.navigationSubmit))
                    expect(formViewModel.endPageViewModel).to(beNil())
                    expect(formViewModel.nextPageViewModel!.name).to(equal("end"))
                    expect(formViewModel.isItTheEnd).to(beFalse())
                }
                it("should have correct data if it's an end page") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    formViewModel.currentPageViewModel = formViewModel.nextPageViewModel!
                    formViewModel.currentPageViewModel = formViewModel.nextPageViewModel!
                    expect(formViewModel.currentPageIndex).to(equal(3))
                    expect(formViewModel.currentPageViewModel.name).to(equal("end"))
                    expect(formViewModel.shouldHideProgressBar).to(beTrue())
                    expect(formViewModel.progress).to(equal(1))
                    expect(formViewModel.cancelButtonTitle).to(beNil())
                    expect(formViewModel.showCancelButton).to(beFalse())
                    expect(formViewModel.isCurrentPageValid).to(beTrue())
                    expect(formViewModel.rightBarButtonTitle).to(beNil())
                    expect(formViewModel.endPageViewModel).toNot(beNil())
                    expect(formViewModel.nextPageViewModel).to(beNil())
                    expect(formViewModel.isItTheEnd).to(beTrue())
                }
                it("Should have correct rating in end page") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    formViewModel.currentPageViewModel = formViewModel.nextPageViewModel!
                    formViewModel.currentPageViewModel = formViewModel.nextPageViewModel!

                    (self.model.pages.first?.fields.first as? MoodFieldModel)?.fieldValue = 4
                    expect(formViewModel.endPageViewModel?.formRating).to(equal(4))
                }
            }

            context("When formViewModel is reset") {
                it("Should have correct initial data") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    formViewModel.currentPageViewModel = formViewModel.nextPageViewModel!
                    formViewModel.currentPageViewModel = formViewModel.nextPageViewModel!
                    formViewModel.reset()

                    expect(formViewModel).toNot(beNil())
                    expect(formViewModel.model).toNot(beNil())
                    expect(formViewModel.currentPageIndex).to(equal(0))
                    expect(formViewModel.currentPageViewModel.name).to(equal("start"))
                    expect(formViewModel.id).to(equal(self.model.appId))
                    expect(formViewModel.shouldHideProgressBar).to(beTrue())
                    expect(formViewModel.progress).to(equal(0.25))
                    expect(formViewModel.accentColor).to(equal(self.model.theme.accentColor))
                    expect(formViewModel.backgrounColor).to(equal(self.model.theme.backgroundColor))
                    expect(formViewModel.statusBarColor).to(equal(self.model.theme.statusBarColor))
                    expect(formViewModel.headerColor).to(equal(self.model.theme.accentColor))
                    expect(formViewModel.textOnAccentColor).to(equal(self.model.theme.textOnAccentColor))
                    expect(formViewModel.cancelButtonTitle).to(beNil())
                    expect(formViewModel.showCancelButton).to(beFalse())
                    expect(formViewModel.isCurrentPageValid).to(beTrue()) // should be false but this needs refactoring isViewCurrentlyVisible
                    expect(formViewModel.firstPageViewModel?.name).to(equal(formViewModel.currentPageViewModel.name))
                    expect(formViewModel.rightBarButtonTitle).to(equal(self.model.copyModel.navigationNext))
                    expect(formViewModel.endPageViewModel).to(beNil())
                    expect(formViewModel.nextPageViewModel!.name).to(equal("Third"))
                    expect(formViewModel.isItTheEnd).to(beFalse())
                }
            }
        }
    }
}
