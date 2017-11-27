//
//  ParagraphFieldModelTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class ParagraphFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = UBMock.pageMock()
        var model: BaseFieldModel?

        describe("ParagraphModel") {
            it("init ParagraphModel") {
                model = ParagraphFieldModel(json: JSON(parseJSON: "{\"title\":\"test\"}"), pageModel: pageModel)
                expect(model).toNot(beNil())
            }
        }
    }
}
