//
//  OptionsFieldModelTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class OptionsFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = UBMock.pageMock()
        var model: OptionsFieldModel?

        describe("OptionsFieldModel") {
            beforeEach {
                model = OptionsFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\"}"))
            }
            it("init OptionsFieldModel") {
                expect(model).toNot(beNil())
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
