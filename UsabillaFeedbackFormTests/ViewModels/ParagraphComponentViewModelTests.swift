//
//  ParagraphComponentViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class ParagraphComponentViewModelTests: QuickSpec {

    override func spec() {

        var viewModel: ParagraphComponentViewModel!
        var model: ParagraphFieldModel!
        let pageModel = PageModel(pageNumber: 0, pageName: "")
        let theme = UsabillaTheme()

        describe("ParagraphComponentViewModelTests") {

            context("when paragraph has no value") {
                it("should return a nil value") {
                    model = ParagraphFieldModel(json: JSON.parse("{\"name\":\"paragraph\", \"html\": 0}"), pageModel: pageModel)
                    viewModel = ParagraphComponentViewModel(model: model, theme: theme)
                    expect(viewModel.value).to(beNil())
                }
            }

            context("when paragraph is not html") {
                it("should return a normal string") {
                    model = ParagraphFieldModel(json: JSON.parse("{\"name\":\"paragraph\", \"html\": 0, \"text\": \"hello\"}"), pageModel: pageModel)
                    viewModel = ParagraphComponentViewModel(model: model, theme: theme)
                    expect(viewModel.value).to(equal("hello"))
                }
            }

            context("when paragraph is html") {
                it("should return a attributed string") {
                    model = ParagraphFieldModel(json: JSON.parse("{\"name\":\"paragraph\", \"html\": true, \"text\": \"hello<b> you</b>\"}"), pageModel: pageModel)
                    viewModel = ParagraphComponentViewModel(model: model, theme: theme)
                    expect(viewModel.value).to(equal("hello you"))
                }
            }
        }
    }
}
