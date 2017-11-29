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

        beforeSuite {
            model = ScreenshotModel(json: JSON(parseJSON: "{\"name\":\"image\"}"))
            viewModel = BaseImageComponentViewModel<ScreenshotModel>(model: model, theme: UsabillaTheme())
        }

        describe("BaseImageComponentViewModelTests") {
            context("when changing value") {
                it("should update model") {
                    let image = Icons.imageOfAddImage(color: .black)
                    viewModel.value = image
                    expect(model.image).to(equal(image))
                }
                it("should notify the delegate") {
                    let delegate = MockBaseComponentViewModelDelegate()
                    viewModel.delegate = delegate
                    waitUntil(timeout: 1.0) { done in
                        delegate.onValueDidChange = done
                        viewModel.value = nil
                    }
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
