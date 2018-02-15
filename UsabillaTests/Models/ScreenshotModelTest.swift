//
//  ScreenshotModelTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 16/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class ScreenshotModelTest: QuickSpec {

    override func spec() {
        var model: ScreenshotModel!

        beforeEach {
            model = ScreenshotModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\"}"), screenShot: nil)
        }

        describe("ScreenshotModel") {
            it("init ScreenshotModel") {
                model = ScreenshotModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\"}"), screenShot: nil)
                expect(model).toNot(beNil())
                expect(model?.image).to(beNil())

                model = ScreenshotModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\"}"), screenShot: UIImage())
                expect(model).toNot(beNil())
                expect(model?.image).toNot(beNil())
            }

            it("ScreenshotModel base64Value") {
                model.image = nil
                expect(model.base64Value).to(beNil())
            }

            it("ScreenshotModel tobase64String()") {
                let bundle = Bundle(for: type(of: self))
                model.image = UIImage(named: "Rectangle", in: bundle, compatibleWith: nil)
                let base64 = model.toBase64String()!
                expect(base64).toNot(beNil())
                expect(base64.count).to(beGreaterThan(0))
            }

            it("StringField isValid") {
                model.image = nil
                model.required = false
                expect(model.isValid()).to(beTrue())
                model.required = true
                expect(model.isValid()).to(beFalse())
                model.image = UIImage()
                expect(model.isValid()).to(beTrue())
            }
        }
    }
}
