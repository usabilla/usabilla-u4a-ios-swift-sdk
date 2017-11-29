//
//  BaseStringComponentViewModelTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class BaseStringComponentViewModelTests: QuickSpec {

    override func spec() {
        var viewModel: BaseStringComponentViewModel<StringFieldModel>!
        var model: StringFieldModel!

        beforeSuite {
            model = StringFieldModel(json: JSON(parseJSON: "{\"name\":\"test\"}"))
            viewModel = BaseStringComponentViewModel<StringFieldModel>(model: model, theme: UsabillaTheme())
        }

        describe("BaseStringComponentViewModelTests") {
            context("when updating value") {
                it("should update model") {
                    viewModel.value = ""
                    expect(model.fieldValue).to(equal(""))
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
                    viewModel.value = "hello"
                    expect(viewModel.value).to(equal("hello"))
                }
            }
        }
    }
}
