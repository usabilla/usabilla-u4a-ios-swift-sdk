//
//  BaseImageComponentViewModelTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class BaseImageComponentViewModelTests: QuickSpec {

    override func spec() {

        var viewModel: BaseImageComponentViewModel<ScreenshotModel>!
        var model: ScreenshotModel!
        let pageModel = UBMock.pageMock()

        beforeSuite {
            model = ScreenshotModel(json: JSON(parseJSON: "{\"name\":\"image\"}"), pageModel: pageModel)
            viewModel = BaseImageComponentViewModel<ScreenshotModel>(model: model, theme: UsabillaTheme())
        }

        describe("BaseImageComponentViewModelTests") {
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
