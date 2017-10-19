//
//  MoodFieldModelTests.swift
//  Usabilla
//
//  Created by Adil Bougamza on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Usabilla

class MoodFieldModelTests: QuickSpec {
    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        var model: MoodFieldModel?

        describe("MoodFieldModel") {
            context("When MoodFieldModel is initlized with correct json") {
                it("should have the correct values set up with 5 emojis") {
                    model = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"points\": \"5\"}"), pageModel: pageModel)
                    expect(model).toNot(beNil())
                    expect(model?.points).to(equal(5))
                    expect(model?.mode).to(equal(RatingMode.emoticon))
                }
                it("should have the correct values set up with 3 emojis") {
                    model = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"points\": \"3\"}"), pageModel: pageModel)
                    expect(model).toNot(beNil())
                    expect(model?.points).to(equal(3))
                    expect(model?.mode).to(equal(RatingMode.emoticon))
                }
                it("should have the correct values set up with 1 emojis") {
                    model = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"points\": \"1\"}"), pageModel: pageModel)
                    expect(model).toNot(beNil())
                    expect(model?.points).to(equal(1))
                    expect(model?.mode).to(equal(RatingMode.emoticon))
                }
                it("should have the correct values for star") {
                    model = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"points\": \"1\", \"mode\": \"star\"}"), pageModel: pageModel)
                    expect(model).toNot(beNil())
                    expect(model?.points).to(equal(5))
                    expect(model?.mode).to(equal(RatingMode.star))
                }
            }
            context("When MoodFieldModel is initlized with no points") {
                it("should have set points to 5") {
                    model = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: pageModel)
                    expect(model).toNot(beNil())
                    expect(model?.points).to(equal(5))
                }
            }
        }
    }
}
