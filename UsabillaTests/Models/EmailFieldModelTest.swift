//
//  EmailFieldModelTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class EmailFieldModelTest: QuickSpec {

    override func spec() {
        var model: EmailFieldModel!

        describe("EmailFieldModel") {
            beforeEach {
                model = EmailFieldModel(json: JSON(parseJSON: "{\"title\":\"test\"}"))
            }
            it("init EmailFieldModel") {
                model = EmailFieldModel(json: JSON(parseJSON: "{\"title\":\"test\"}"))
                expect(model).toNot(beNil())
            }
            it("EmailFieldModel isValidEmail") {
                expect(model.isValidEmail(testStr: "test")).to(beFalse())
                expect(model.isValidEmail(testStr: "test@")).to(beFalse())
                expect(model.isValidEmail(testStr: "test@test")).to(beFalse())
                expect(model.isValidEmail(testStr: "test@test.com")).to(beTrue())
            }
            it("EmailFieldModel isValid") {
                model.fieldValue = nil
                model.required = false
                expect(model.isValid()).to(beTrue())
                model.required = true
                expect(model.isValid()).to(beFalse())
                model.fieldValue = "test"
                expect(model.isValid()).to(beFalse())
                model.fieldValue = "test@test.com"
                expect(model.isValid()).to(beTrue())
            }
            it("should export the value correctly") {
                model.fieldValue = nil
                expect(model.exportableValue).to(beNil())
                model.fieldValue = "test"
                let value = model.exportableValue as! String
                expect(value).to(equal("test"))
            }
        }
    }
}
