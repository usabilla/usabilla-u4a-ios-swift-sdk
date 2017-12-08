//
//  RadioComponentViewModelTests.swift
//  UsabillaTests
//
//  Created by Adil Bougamza on 08/12/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class RadioComponentViewModelTests: QuickSpec {
    override func spec() {
        let pageModel = UBMock.pageMock()
        let theme = UsabillaTheme()

        describe("RadioComponentViewModel") {
            context("radioButton viewModel is initialized") {
                it("should have correct accessiblity label") {
                    let model = RadioFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let viewModel = RadioComponentViewModel(model: model, theme: theme)
                    expect(viewModel.accessibilityLabelDetail).to(equal("Choose from 0 options, One option possible"))
                }
            }
        }
    }
}
