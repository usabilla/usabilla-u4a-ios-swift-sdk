//
//  EmailFieldModelTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class EmailFieldModelTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test", themeConfig: UsabillaThemeConfigurator())
        var model: EmailFieldModel?

        describe("EmailFieldModel") {
            it("init EmailFieldModel") {
                model = EmailFieldModel(json: JSON.parse("{\"title\":\"test\"}"), pageModel: pageModel)
                expect(model).toNot(beNil())
            }

            it("EmailFieldModel isValidEmail") {
                expect(model?.isValidEmail(testStr: "test")).to(beFalse())
                expect(model?.isValidEmail(testStr: "test@")).to(beFalse())
                expect(model?.isValidEmail(testStr: "test@test")).to(beFalse())
                expect(model?.isValidEmail(testStr: "test@test.com")).to(beTrue())

            }

            it("EmailFieldModel isValid") {
                model?.fieldValue = nil

                model?.isViewCurrentlyVisible = false
                model?.required = true
                expect(model?.isValid()).to(beTrue())

                model?.isViewCurrentlyVisible = true
                model?.required = false
                expect(model?.isValid()).to(beTrue())

                model?.isViewCurrentlyVisible = true
                model?.required = true
                expect(model?.isValid()).to(beFalse())

                expect(model?.isValid()).to(beFalse())

                model?.fieldValue = "test"
                expect(model?.isValid()).to(beFalse())

                model?.fieldValue = "test@test.com"
                expect(model?.isValid()).to(beTrue())
            }
        }

    }
}
