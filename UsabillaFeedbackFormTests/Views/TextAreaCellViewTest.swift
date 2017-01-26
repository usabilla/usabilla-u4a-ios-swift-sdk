//
//  TextAreaCellViewTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class TextAreaCellViewTest: QuickSpec {
    
    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test", themeConfig: UsabillaThemeConfigurator())
        
        var view: TextAreaCellView?
        var model: TextAreaFieldModel!
        
        describe("TextAreaCellViewTest") {
            
            it("TextAreaCellViewTest init with wrong model") {
                view = TextAreaCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())
                let wrongModel = StringFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\"}"), pageModel: pageModel)
            
                view?.setFeedbackItem(wrongModel)
                expect(view?.model).to(beNil())
            }
            
            it("TextAreaCellViewTest init wtithout value") {
                view = TextAreaCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())
                model = TextAreaFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\"}"), pageModel: pageModel)
                
                view?.setFeedbackItem(model)
                view?.applyCustomisations()
                expect(view?.isPlaceholder).to(beTrue())
                expect(view?.textView.text).to(equal("myplaceholder"))
            }
            
            it("TextAreaCellViewTest init with value") {
                view = TextAreaCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())
                model = TextAreaFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\"}"), pageModel: pageModel)
                model.fieldValue = "test"
                view?.setFeedbackItem(model)
                view?.applyCustomisations()
                expect(view?.isPlaceholder).to(beFalse())
                expect(view?.textView.text).to(equal("test"))
            }
            
            
            it("TextAreaCellViewTest begin editing") {
                view?.textViewDidBeginEditing(view!.textView)
                view?.textView.text = "hey"
            }
            
            it("TextAreaCellViewTest writing text should update model") {
                view?.textView.text = "hello"
                view?.textViewDidChange(view!.textView)
                expect(model.fieldValue).to(equal("hello"))
            }
            
            it("TextAreaCellViewTest end editing with value") {
                view?.textViewDidEndEditing(view!.textView)
                expect(model.fieldValue).to(equal("hello"))
            }
            
            it("TextAreaCellViewTest end editing without value") {
                view?.textView.text = ""
                view?.textViewDidChange(view!.textView)
                view?.textViewDidEndEditing(view!.textView)
                expect(model.fieldValue).to(beNil())
                expect(view?.textView.text).to(equal("myplaceholder"))
            }
        }
    }
}
