//
//  StringFieldModeltest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class StringFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = UBMock.pageMock()
        var model: StringFieldModel?

        describe("StringFieldModel") {
            it("init StringFieldModel") {
                model = StringFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\"}"))
                expect(model).toNot(beNil())
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
        }
    }
}
