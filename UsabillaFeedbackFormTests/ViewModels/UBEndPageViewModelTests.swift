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
    let theme = UsabillaTheme()

    override func spec() {
        describe("UBEndPageViewModelTests") {
            beforeSuite {
                self.formModel = UBMock.formMock()
                self.endPageModel = (self.formModel.pages.last as? UBEndPageModel)!
            }

            context("When initilized") {
                it("should have the correct data") {
                    let viewModel = UBEndPageViewModel(model: self.endPageModel, theme: self.theme)
                    let headerFieldModel = self.endPageModel.fields.first as? HeaderFieldModel
                    let stringFieldModel = self.endPageModel.fields[1] as? StringFieldModel
                    expect(viewModel.headerText).to(equal(headerFieldModel?.fieldValue))
                    expect(viewModel.thankyouText).to(equal(stringFieldModel?.fieldValue))
                    expect(viewModel.moreFeedbackText).to(equal(self.endPageModel.copy?.moreFeedback))
                    expect(viewModel.canGiveMoreFeedback).to(beFalse())
                    expect(viewModel.theme).toNot(beNil())
                }
            }
        }
    }
}
