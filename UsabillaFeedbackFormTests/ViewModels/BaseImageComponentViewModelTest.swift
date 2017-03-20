//
//  BaseImageComponentViewModelTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class BaseImageComponentViewModelTest: QuickSpec {
    
    override func spec() {
        
        var viewModel: BaseImageComponentViewModel<ScreenshotModel>!
        var model: ScreenshotModel!
        let pageModel = PageModel(pageNumber: 0, pageName: "", themeConfig: UsabillaThemeConfigurator())
        
        beforeSuite {
            model = ScreenshotModel(json: JSON.parse("{\"name\":\"image\"}"), pageModel: pageModel)
            viewModel = BaseImageComponentViewModel<ScreenshotModel>(model: model)
        }
        
        describe("BaseImageComponentViewModelTest") {
            context("when changing value") {
                it("should update model") {
                    let image = Icons.imageOfAddImage(color: .black)
                    viewModel.value = image
                    expect(model.image).to(equal(image))
                }
                
                it("should update viewModel") {
                    let image = Icons.imageOfEdit(color: .black)
                    viewModel.value = image
                    expect(viewModel.value).to(equal(image))
                }
            }
        }
    }
}
