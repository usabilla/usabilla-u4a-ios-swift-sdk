//
//  BaseStringComponentViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class BaseStringComponentViewModelTests: QuickSpec {

    override func spec() {

        var viewModel: BaseStringComponentViewModel<StringFieldModel>!
        var model: StringFieldModel!
        let pageModel = PageModel(pageNumber: 0, pageName: "")

        beforeSuite {
            model = StringFieldModel(json: JSON.parse("{\"name\":\"test\"}"), pageModel: pageModel)
            viewModel = BaseStringComponentViewModel<StringFieldModel>(model: model, theme: UsabillaTheme())
        }

        describe("BaseStringComponentViewModelTests") {
            context("when updating value") {
                it("should update model") {
                    viewModel.value = ""
                    expect(model.fieldValue).to(equal(""))
                }

                it("should update viewModel") {
                    viewModel.value = "hello"
                    expect(viewModel.value).to(equal("hello"))
                }
            }
        }
    }
}
