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
            beforeEach {
                model = OptionsFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: pageModel)
            }
            it("init OptionsFieldModel") {
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
            it("should export the value correctly") {
                model?.fieldValue = []
                expect(model?.exportableValue).to(beNil())
                model?.fieldValue = ["hello"]
                let value = model!.exportableValue as! [String]
                expect(value).to(equal(["hello"]))
            }
        }
    }
}
