//
//  StarCellViewTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 13/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class StarCellViewTest: QuickSpec {
    
    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test", themeConfig: UsabillaThemeConfigurator())
        
        var view: StarCellView?
        var model: StarFieldModel!
        
        beforeSuite {
            model = StarFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\"}"), pageModel: pageModel)
        }
        
        describe("TextAreaCellViewTest") {
            
            it("TextAreaCellViewTest init with wrong model") {
                view = StarCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())
                let wrongModel = StringFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\"}"), pageModel: pageModel)
                
                view?.setFeedbackItem(wrongModel)
                expect(view?.starModel).to(beNil())
            }
            
            it("TextAreaCellViewTest init wtithout value") {
                view = StarCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())
                view?.setFeedbackItem(model)
                view?.applyCustomisations()
                expect(view?.starModel.fieldValue).to(beNil())
                expect(view?.ratingControl.rating).to(beNil())
            }
            
            it("TextAreaCellViewTest init with value") {
                view = StarCellView(style: .default, reuseIdentifier: nil)
                expect(view).toNot(beNil())
                model.fieldValue = 3
                view?.setFeedbackItem(model)
                view?.applyCustomisations()
                expect(view?.starModel.fieldValue).to(equal(3))
                expect(view?.ratingControl.rating).to(equal(3))
                expect(view?.ratingControl.mode).to(equal(RatingMode.rating))

            }
            
            
            it("changes the value correctly") {
                
            }
//
//            it("TextAreaCellViewTest writing text should update model") {
//                view?.textView.text = "hello"
//                view?.textViewDidChange(view!.textView)
//                expect(model.fieldValue).to(equal("hello"))
//            }
//            
//            it("TextAreaCellViewTest end editing with value") {
//                view?.textViewDidEndEditing(view!.textView)
//                expect(model.fieldValue).to(equal("hello"))
//            }
//            
//            it("TextAreaCellViewTest end editing without value") {
//                view?.textView.text = ""
//                view?.textViewDidChange(view!.textView)
//                view?.textViewDidEndEditing(view!.textView)
//                expect(model.fieldValue).to(beNil())
//                expect(view?.textView.text).to(equal("myplaceholder"))
//            }
        }
    }
}
