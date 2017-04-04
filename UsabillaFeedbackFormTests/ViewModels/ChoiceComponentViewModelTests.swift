//
//  ChoiceComponentViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class ChoiceComponentViewModelTests: QuickSpec {

    override func spec() {

        var viewModel: ChoiceComponentViewModel!
        var model: ChoiceFieldModel!
        let pageModel = PageModel(pageNumber: 0, pageName: "", themeConfig: UsabillaTheme())

        beforeSuite {
            model = ChoiceFieldModel(json: JSON.parse("{\"name\":\"test\"}"), pageModel: pageModel)
            viewModel = ChoiceComponentViewModel(model: model)
        }

        describe("ChoiceComponentViewModelTests") {
            it("viewModel options should match model options") {
                expect(model.options.count).to(equal(viewModel.options.count))
            }

            context("when updating value") {
                it("should update model") {
                    viewModel.value = "hello"
                    expect(model.fieldValue).to(equal(["hello"]))
                }

                it("should update viewModel") {
                    viewModel.value = "hi"
                    expect(viewModel.value).to(equal("hi"))
                }
            }
        }
    }
}
