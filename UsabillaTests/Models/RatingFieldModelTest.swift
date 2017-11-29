//
//  RatingFieldModelTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 15/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class RatingFieldModelTest: QuickSpec {

    override func spec() {
        var model: RatingFieldModel?

        describe("RatingFieldModel") {
            beforeEach {
                model = RatingFieldModel(json: JSON(parseJSON: "{\"title\":\"test\"}"))
            }
            it("init RatingFieldModel") {
                expect(model).toNot(beNil())
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
