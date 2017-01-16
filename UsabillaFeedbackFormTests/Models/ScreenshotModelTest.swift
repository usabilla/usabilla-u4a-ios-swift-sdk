//
//  ScreenshotModelTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class ScreenshotModelTest: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test", themeConfig: UsabillaThemeConfigurator())
        var model: ScreenshotModel?
        
        describe("ScreenshotModel") {
            it("init ScreenshotModel") {
                model = ScreenshotModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: pageModel, screenShot: nil)
                expect(model).toNot(beNil())
                expect(model?.screenshot).to(beNil())
                
                model = ScreenshotModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: pageModel, screenShot: UIImage())
                expect(model).toNot(beNil())
                expect(model?.screenshot).toNot(beNil())
            }
            
            it("ScreenshotModel base64Value") {
                model?.screenshot = nil
                expect(model?.base64Value).to(beNil())
            }
            
            it("ScreenshotModel tobase64String()") {
                let bundle = Bundle(for: type(of:self))
                model?.screenshot = UIImage(named: "Rectangle", in: bundle, compatibleWith: nil)
                var base64 = model?.toBase64String()
                expect(base64).toNot(beNil())
                expect(base64?.characters.count).to(beGreaterThan(0))
            }
            
            it("StringField isValid") {
                model?.screenshot = nil
                
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
                
                model?.screenshot = nil
                expect(model?.isValid()).to(beFalse())
                
                model?.screenshot = UIImage()
                expect(model?.isValid()).to(beTrue())
            }

            
        }
    }
}
