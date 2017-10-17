//
//  PickerFieldModelTests.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 25/07/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class PickerFieldModelTests: QuickSpec {

    var pageModel: PageModel!
    var model: PickerFieldModel!

    override func spec() {
        beforeSuite {
            self.pageModel = PageModel(pageNumber: 0, pageName: "test")
            self.model = PickerFieldModel(json: JSON(parseJSON: "{\"title\":\"test\"}"), pageModel: self.pageModel)
            self.model.fieldID = "id"
        }

        describe("PickerFieldModel") {
            context("When required") {
                beforeEach {
                    self.model.required = true
                }
                it("does not valdiate with an empty value") {
                    self.model.fieldValue = []
                    expect(self.model.isValid()).to(beFalse())
                }
                it("does valdiate with an non empty value") {
                    self.model.fieldValue = ["a"]
                    expect(self.model.isValid()).to(beTrue())
                }
            }
            context("When not required") {
                beforeEach {
                    self.model.required = false
                }
                it("does valdiate with an empty value") {
                    self.model.fieldValue = []
                    expect(self.model.isValid()).to(beTrue())
                }
                it("does valdiate with an non empty value") {
                    self.model.fieldValue = ["a"]
                    expect(self.model.isValid()).to(beTrue())
                }
            }
        }
    }
}
