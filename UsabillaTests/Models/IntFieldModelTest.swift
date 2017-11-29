//
//  IntFieldModelTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class IntFieldModelTest: QuickSpec {

    override func spec() {
        var model: IntFieldModel?

        describe("IntFieldModel") {
            beforeEach {
                model = IntFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\"}"))
            }
            it("init IntFieldModel") {
                expect(model).toNot(beNil())
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
            it("should export the value correctly") {
                model?.fieldValue = nil
                expect(model?.exportableValue).to(beNil())
                model?.fieldValue = 17
                let value = model!.exportableValue as! Int
                expect(value).to(equal(17))
            }
        }
    }
}
