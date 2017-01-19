//
//  RatingFieldModelTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 15/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class RatingFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test", themeConfig: UsabillaThemeConfigurator())
        var model: RatingFieldModel?

        describe("RatingFieldModel") {
            it("init RatingFieldModel") {
                model = RatingFieldModel(json: JSON.parse("{\"title\":\"test\"}"), pageModel: pageModel)
                expect(model).toNot(beNil())
                expect(model?.isNPS).to(beFalse())
            }

            it("init RatingFieldModel NPS") {
                model = RatingFieldModel(json: JSON.parse("{\"title\":\"test\"}"), pageModel: pageModel, isNPS: true)
                expect(model).toNot(beNil())
                expect(model?.isNPS).to(beTrue())
            }
        }
    }
}
