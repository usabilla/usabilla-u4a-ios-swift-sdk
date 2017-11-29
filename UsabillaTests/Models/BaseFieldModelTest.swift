//
//  BaseFieldModelTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class BaseFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = UBMock.pageMock()
        var base: BaseFieldModel?

        describe("BaseFieldModel") {
            it("init BaseFieldModel") {
                base = BaseFieldModel(json: JSON(parseJSON: "{\"title\":\"test\"}"))
                expect(base).toNot(beNil())
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
