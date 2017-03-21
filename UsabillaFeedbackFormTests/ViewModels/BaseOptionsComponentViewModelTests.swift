//
//  BaseOptionsComponentViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class BaseOptionsComponentViewModelTests: QuickSpec {
    
    override func spec() {
        
        var viewModel: BaseOptionsComponentViewModel<OptionsFieldModel>!
        var model: OptionsFieldModel!
        let pageModel = PageModel(pageNumber: 0, pageName: "", themeConfig: UsabillaThemeConfigurator())
        
        beforeSuite {
            model = OptionsFieldModel(json: JSON.parse("{\"name\":\"test\"}"), pageModel: pageModel)
            viewModel = BaseOptionsComponentViewModel<OptionsFieldModel>(model: model)
        }
        
        describe("BaseOptionsComponentViewModelTests") {
            it("viewModel options should match model options") {
                expect(model.options.count).to(equal(viewModel.options.count))
            }

            context("when updating value") {
                it("should update model") {
                    viewModel.value = []
                    expect(model.fieldValue).to(equal([]))
                }
                
                it("should update viewModel") {
                    viewModel.value = ["hello"]
                    expect(viewModel.value).to(equal(["hello"]))
                }
            }
        }
    }
}
