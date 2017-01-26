//
//  TextInputCellViewTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 26/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class TextInputCellViewTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test", themeConfig: UsabillaThemeConfigurator())

        var view: TextInputCellView?
        var model: TextFieldModel?

        describe("TextInputCellViewTesT") {

            let json = JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\"}")

            it("TextInputCellViewTesT init with wrong model") {
                view = TextInputCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())
                let wrongModel = ChoiceFieldModel(json: json, pageModel: pageModel)

                view?.setFeedbackItem(wrongModel)
                expect(view?.model).to(beNil())
            }

            it("TextInputCellViewTesT init with StringFieldModel") {
                view = TextInputCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())
                let stringModel = StringFieldModel(json: json, pageModel: pageModel)
                view?.setFeedbackItem(stringModel)
                view?.applyCustomisations()
                expect(view!.model).toNot(beNil())
            }

            it("TextInputCellViewTesT init without value") {
                view = TextInputCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())
                model = TextFieldModel(json: json, pageModel: pageModel)
                view?.setFeedbackItem(model!)
                expect(view?.textField.attributedPlaceholder?.string).to(equal("myplaceholder"))
                view?.applyCustomisations()
            }

            it("TextInputCellViewTesT init with value") {
                view = TextInputCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())

                let json2 = JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"defaultValue\": \"hello\"}")
                model = TextFieldModel(json: json2, pageModel: pageModel)
                view?.setFeedbackItem(model!)
                expect(view?.textField.attributedPlaceholder?.string).to(equal("myplaceholder"))
                expect(view?.textField.text).to(equal("hello"))
            }

            it("TextInputCellViewTesT writing text should update model") {
                view?.textField.text = "hi"
                view?.textFieldDidChange()
                expect(model?.fieldValue).to(equal("hi"))
            }

            it("TextInputCellViewTesT end editing with value") {
                view?.textField.text = "Bonjour"
                view?.textFieldDidEndEditing(view!.textField)
                expect(model!.fieldValue).to(equal("Bonjour"))
            }
        }
    }
}
