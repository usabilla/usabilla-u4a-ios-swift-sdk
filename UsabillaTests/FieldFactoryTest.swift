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
        describe("Field Factory") {
            it("paragraph type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"paragraph\"}"), maskModel: nil)
                expect(field is ParagraphFieldModel).to(beTrue())
            }
            it("titleParagraph type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"titleParagraph\"}"), maskModel: nil)
                expect(field is ParagraphFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"text\"}"), maskModel: nil)
                expect(field is TextFieldModel).to(beTrue())
            }
            it("choice type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"choice\"}"), maskModel: nil)
                expect(field is PickerFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"email\"}"), maskModel: nil)
                expect(field is EmailFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"textArea\"}"), maskModel: nil)
                expect(field is TextAreaFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"mood\"}"), maskModel: nil)
                expect(field is MoodFieldModel).to(beTrue())
                expect((field as? MoodFieldModel)?.mode).to(equal(RatingMode.emoticon))
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"mood\", \"mode\":\"star\"}"), maskModel: nil)
                expect(field is MoodFieldModel).to(beTrue())
                expect((field as? MoodFieldModel)?.mode).to(equal(RatingMode.star))
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"rating\"}"), maskModel: nil)
                expect(field is RatingFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"radio\"}"), maskModel: nil)
                expect(field is RadioFieldModel).to(beTrue())
            }
            it("text type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"checkbox\"}"), maskModel: nil)
                expect(field is CheckboxFieldModel).to(beTrue())
            }

            it("unknown type") {
                let field = FieldFactory.createField(JSON(parseJSON: "{\"type\":\"unkown\"}"), maskModel: nil)
                expect(field).to(beNil())
            }

            it("unknown type") {
                let field = FieldFactory.createField(JSON(parseJSON: ""), maskModel: nil)
                expect(field).to(beNil())
            }
        }
    }
}
