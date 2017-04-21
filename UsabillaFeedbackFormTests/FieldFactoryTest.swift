//
//  FieldFactoryTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class FieldFactoryTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        describe("Field Factory") {
            it("paragraph type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"paragraph\"}"), pagemodel: pageModel)
                expect(field is ParagraphFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"text\"}"), pagemodel: pageModel)
                expect(field is TextFieldModel).to(beTrue())
            }
            it("choice type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"choice\"}"), pagemodel: pageModel)
                expect(field is ChoiceFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"email\"}"), pagemodel: pageModel)
                expect(field is EmailFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"textArea\"}"), pagemodel: pageModel)
                expect(field is TextAreaFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"comment\"}"), pagemodel: pageModel)
                expect(field is CommentFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"mood\"}"), pagemodel: pageModel)
                expect(field is MoodFieldModel).to(beTrue())
                expect((field as? MoodFieldModel)?.mode).to(equal(RatingMode.emoticon))
            }
            it("text type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"mood\", \"mode\":\"star\"}"), pagemodel: pageModel)
                expect(field is MoodFieldModel).to(beTrue())
                expect((field as? MoodFieldModel)?.mode).to(equal(RatingMode.star))
            }
            it("text type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"rating\"}"), pagemodel: pageModel)
                expect(field is RatingFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"radio\"}"), pagemodel: pageModel)
                expect(field is RadioFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"checkbox\"}"), pagemodel: pageModel)
                expect(field is CheckboxFieldModel).to(beTrue())
            }

            it("unknown type") {
                let field = FieldFactory.createField(JSON.parse("{\"type\":\"unkown\"}"), pagemodel: pageModel)
                expect(field).to(beNil())
            }

            it("unknown type") {
                let field = FieldFactory.createField(JSON.parse(""), pagemodel: pageModel)
                expect(field).to(beNil())
            }
        }
    }
}
