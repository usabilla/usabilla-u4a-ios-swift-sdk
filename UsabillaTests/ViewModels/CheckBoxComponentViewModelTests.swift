//
//  CheckBoxComponentViewModelTests.swift
//  UsabillaTests
//
//  Created by Adil Bougamza on 08/12/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class CheckBoxComponentViewModelTests: QuickSpec {

    override func spec() {
        let pageModel = UBMock.pageMock()
        let theme = UsabillaTheme()

        describe("CheckBoxComponentViewModel") {
            context("checkbox viewModel is initialized") {
                it("should have correct accessiblity label") {
                    let model = CheckboxFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let viewModel = CheckBoxComponentViewModel(model: model, theme: theme)
                    expect(viewModel.accessibilityLabelDetail).to(equal("Choose from 0 options, Multiple options possible"))
                }
            }
        }
    }
}

