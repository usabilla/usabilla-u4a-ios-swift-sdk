//
//  ParagraphFieldModelTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class ParagraphFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test", theme: UsabillaTheme())
        var model: BaseFieldModel?

        describe("ParagraphModel") {
            it("init ParagraphModel") {
                model = ParagraphFieldModel(json: JSON.parse("{\"title\":\"test\"}"), pageModel: pageModel)
                expect(model).toNot(beNil())
            }

            it("BaseFieldModel convertToJson") {
                let res = model?.convertToJSON()
                expect(res).to(beNil())
            }
        }
    }
}
