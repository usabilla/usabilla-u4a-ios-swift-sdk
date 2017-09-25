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
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        var model: RatingFieldModel?

        describe("RatingFieldModel") {
            beforeEach {
                model = RatingFieldModel(json: JSON.parse("{\"title\":\"test\"}"), pageModel: pageModel)
            }
            it("init RatingFieldModel") {
                expect(model).toNot(beNil())
                expect(model?.isNPS).to(beFalse())
            }
            it("init RatingFieldModel NPS") {
                model = RatingFieldModel(json: JSON.parse("{\"title\":\"test\"}"), pageModel: pageModel, isNPS: true)
                expect(model).toNot(beNil())
                expect(model?.isNPS).to(beTrue())
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
