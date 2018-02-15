//
//  ParagraphFieldModelTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class ParagraphFieldModelTest: QuickSpec {

    override func spec() {

        describe("ParagraphModel") {
            it("init ParagraphModel") {
                let model = ParagraphFieldModel(json: JSON(parseJSON: "{\"title\":\"test\"}"))
                expect(model).toNot(beNil())
            }
        }
    }
}
