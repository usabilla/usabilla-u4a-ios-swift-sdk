//
//  BaseIntComponentViewModelTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 17/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class BaseIntComponentViewModelTests: QuickSpec {

    override func spec() {

        var viewModel: BaseIntComponentViewModel<IntFieldModel>!
        var model: IntFieldModel!
        let pageModel = UBMock.pageMock()

        beforeSuite {
            model = IntFieldModel(json: JSON(parseJSON: "{\"name\":\"mood\"}"), pageModel: pageModel)
            viewModel = BaseIntComponentViewModel<IntFieldModel>(model: model, theme: UsabillaTheme())
        }

        describe("BaseIntComponentViewModelTests") {
            context("when changing value") {
                it("should update model") {
                    viewModel.value = 5
                    expect(model.fieldValue).to(equal(5))
                }

                it("should update viewModel") {
                    viewModel.value = 4
                    expect(viewModel.value).to(equal(4))
                }
            }
        }
    }
}
