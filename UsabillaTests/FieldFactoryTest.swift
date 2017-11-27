//
//  FieldFactoryTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class FieldFactoryTest: QuickSpec {

    override func spec() {
        let pageModel = UBMock.pageMock()
        describe("Field Factory") {
            it("paragraph type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"paragraph\"}"), pagemodel: pageModel)
                expect(field is ParagraphFieldModel).to(beTrue())
            }
            it("titleParagraph type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"titleParagraph\"}"), pagemodel: pageModel)
                expect(field is ParagraphFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"text\"}"), pagemodel: pageModel)
                expect(field is TextFieldModel).to(beTrue())
            }
            it("choice type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"choice\"}"), pagemodel: pageModel)
                expect(field is PickerFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"email\"}"), pagemodel: pageModel)
                expect(field is EmailFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"textArea\"}"), pagemodel: pageModel)
                expect(field is TextAreaFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"mood\"}"), pagemodel: pageModel)
                expect(field is MoodFieldModel).to(beTrue())
                expect((field as? MoodFieldModel)?.mode).to(equal(RatingMode.emoticon))
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"mood\", \"mode\":\"star\"}"), pagemodel: pageModel)
                expect(field is MoodFieldModel).to(beTrue())
                expect((field as? MoodFieldModel)?.mode).to(equal(RatingMode.star))
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"rating\"}"), pagemodel: pageModel)
                expect(field is RatingFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"radio\"}"), pagemodel: pageModel)
                expect(field is RadioFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"checkbox\"}"), pagemodel: pageModel)
                expect(field is CheckboxFieldModel).to(beTrue())
            }

            it("unknown type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"unkown\"}"), pagemodel: pageModel)
                expect(field).to(beNil())
            }

            it("unknown type") {
                let field = FieldFactory.createField(JSON(parseJSON: ""), pagemodel: pageModel)
                expect(field).to(beNil())
            }
        }
    }
}
