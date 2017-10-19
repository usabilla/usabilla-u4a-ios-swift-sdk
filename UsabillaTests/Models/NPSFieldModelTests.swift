//
//  NPSFieldModelTests.swift
//  UsabillaTests
//
//  Created by Benjamin Grima on 25/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class NPSFieldModelTests: QuickSpec {
    
    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        var model: NPSFieldModel?
        
        describe("NPSFieldModel") {
            beforeEach {
                model = NPSFieldModel(json: JSON(parseJSON: "{\"title\":\"test\"}"), pageModel: pageModel)
            }
            it("init RatingFieldModel") {
                expect(model).toNot(beNil())
            }
            it("should export the value correctly") {
                model?.fieldValue = nil
                expect(model?.exportableValue).to(beNil())
                model?.fieldValue = 17
                let value = model!.exportableValue as! Int
                expect(value).to(equal(17))
            }
        }
    }
}
