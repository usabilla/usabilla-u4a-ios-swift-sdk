//
//  StringFieldModeltest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class StringFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        var model: StringFieldModel?

        describe("StringFieldModel") {
            it("init StringFieldModel") {
                model = StringFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: pageModel)
                expect(model).toNot(beNil())
            }

            it("StringField fieldValue") {
                model?.fieldValue = "test1"
                expect(pageModel.fieldValuesCollection["myField"]?.first).to(equal("test1"))
            }

            it("StringField isValid") {
                model?.fieldValue = nil

                model?.required = false
                expect(model?.isValid()).to(beTrue())
                model?.required = true
                expect(model?.isValid()).to(beFalse())
                model?.fieldValue = ""
                expect(model?.isValid()).to(beFalse())
                model?.fieldValue = "test"
                expect(model?.isValid()).to(beTrue())
            }
            it("StringField convertToJson") {
                model?.fieldValue = "hello"
                expect(model?.convertToJSON() as? String).to(equal("hello"))
            }
        }
    }
}
