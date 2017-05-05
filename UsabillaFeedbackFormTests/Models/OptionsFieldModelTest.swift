//
//  OptionsFieldModelTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class OptionsFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        var model: OptionsFieldModel?

        describe("OptionsFieldModel") {
            it("init OptionsFieldModel") {
                model = OptionsFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: pageModel)
                expect(model).toNot(beNil())
            }

            it("OptionsFieldModel fieldValue") {
                model?.fieldValue = ["test1", "test2"]
                expect(pageModel.fieldValuesCollection["myField"]).to(equal(["test1", "test2"]))
            }

            it("OptionsFieldModel isValid") {
                model?.fieldValue = []

                model?.required = false
                expect(model?.isValid()).to(beTrue())
                model?.required = true
                expect(model?.isValid()).to(beFalse())
                model?.fieldValue = ["hello"]
                expect(model?.isValid()).to(beTrue())
            }

            it("StringField convertToJson") {
                model?.fieldValue = []
                expect(model?.convertToJSON()).to(beNil())

                model?.fieldValue = ["hello"]
                expect(model?.convertToJSON() as? [String]).to(equal(["hello"]))
            }

        }
    }
}
