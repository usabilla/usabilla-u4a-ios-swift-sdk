//
//  IntFieldModelTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class IntFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        var model: IntFieldModel?

        describe("IntFieldModel") {
            it("init IntFieldModel") {
                model = IntFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: pageModel)
                expect(model).toNot(beNil())
            }

            it("IntFieldModel fieldValue") {
                model?.fieldValue = 15
                expect(pageModel.fieldValuesCollection["myField"]?.first).to(equal("15"))
            }

            it("StringField isValid") {
                model?.fieldValue = nil
                model?.required = false
                expect(model?.isValid()).to(beTrue())
                model?.required = true
                expect(model?.isValid()).to(beFalse())
                model?.fieldValue = 15
                expect(model?.isValid()).to(beTrue())
            }

            it("StringField convertToJson") {
                model?.fieldValue = 17
                expect(model?.convertToJSON() as? Int).to(equal(17))
            }

        }
    }
}
