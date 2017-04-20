//
//  MoodFieldModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class MoodFieldModelTests: QuickSpec {
    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        var model: MoodFieldModel?

        describe("MoodFieldModel") {

            context("When MoodFieldModel is initlized with correct json") {
                it("should have the correct values set up with 5 emojis") {
                    model = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"points\": 5}"), pageModel: pageModel)
                    expect(model).toNot(beNil())
                    expect(model?.points).to(equal(5))
                }
                it("should have the correct values set up with 5 emojis") {
                    model = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"points\": 3}"), pageModel: pageModel)
                    expect(model).toNot(beNil())
                    expect(model?.points).to(equal(3))
                }
                it("should have the correct values set up with 5 emojis") {
                    model = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"points\": 1}"), pageModel: pageModel)
                    expect(model).toNot(beNil())
                    expect(model?.points).to(equal(1))
                }
            }

            context("When MoodFieldModel is initlized with no points") {
                it("should have set points to 5") {
                    model = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: pageModel)
                    expect(model).toNot(beNil())
                    expect(model?.points).to(equal(5))
                }
            }
        }
    }
}
