//
//  NPSComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 25/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class NPSComponentViewModelTests: QuickSpec {

    override func spec() {

        var viewModel: NPSComponentViewModel!
        var model: NPSFieldModel!
        let pageModel = UBMock.pageMock()

        beforeSuite {
            model = NPSFieldModel(json: UBMock.json("NPSField")!, pageModel: pageModel)
            viewModel = NPSComponentViewModel(model: model, theme: UsabillaTheme())
        }

        describe("NPSComponentViewModel") {
            it("should return the correct highLabel") {
                expect(model.high).to(equal("very likely"))
                expect(viewModel.highLabel).to(equal(model.high))
            }
            it("should return the correct lowLabel") {
                expect(model.low).to(equal("not at all"))
                expect(viewModel.lowLabel).to(equal(model.low))
            }
        }
    }
}
