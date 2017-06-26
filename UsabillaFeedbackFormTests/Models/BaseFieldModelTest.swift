//
//  BaseFieldModelTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class BaseFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        var base: BaseFieldModel?

        describe("BaseFieldModel") {
            it("init BaseFieldModel") {
                base = BaseFieldModel(json: JSON.parse("{\"title\":\"test\"}"), pageModel: pageModel)
                expect(base).toNot(beNil())
            }

            it("BaseFieldModel convertToJson") {
                let res = base?.convertToJSON()
                expect(res).to(beNil())
            }

            it("BaseFieldModel isValid") {
                let res = base?.isValid()
                expect(res).to(beFalse())
            }

            it("BaseFieldModel shouldAppear") {
                let res = base?.shouldAppear()
                expect(res).to(beTrue())
            }

            it("BaseFieldModel shouldAppear with rule") {
                base?.rule = ShowHideRule(dependsOnID: "", targetValues: ["self"], pageModel: pageModel, show: true)
                let res = base?.shouldAppear()
                expect(res).to(beFalse())
            }
        }
    }
}