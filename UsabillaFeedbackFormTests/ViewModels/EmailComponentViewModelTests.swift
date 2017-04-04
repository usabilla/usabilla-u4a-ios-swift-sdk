//
//  EmailComponentViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class EmailComponentViewModelTests: QuickSpec {

    override func spec() {

        var viewModel: EmailComponentViewModel!
        var model: EmailFieldModel!
        let pageModel = PageModel(pageNumber: 0, pageName: "", themeConfig: UsabillaTheme())

        beforeSuite {
            model = EmailFieldModel(json: JSON.parse("{\"name\":\"email\"}"), pageModel: pageModel)
            viewModel = EmailComponentViewModel(model: model)
        }

        describe("EmailComponentViewModelTests") {

            context("when email has no value") {
                it("should be invalid") {
                    expect(viewModel.isValid).to(beFalse())
                }
            }

            context("when email has invalid email") {
                it("should be invalid") {
                    viewModel.value = "test"
                    expect(viewModel.isValid).to(beFalse())
                }
            }

            context("when email has valid email") {
                it("should be invalid") {
                    viewModel.value = "test@test.com"
                    expect(viewModel.isValid).to(beTrue())
                }
            }

        }
    }
}
