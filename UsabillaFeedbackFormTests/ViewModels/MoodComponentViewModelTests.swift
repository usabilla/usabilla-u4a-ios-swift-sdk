//
//  MoodComponentViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 08/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class MoodComponentViewModelTests: QuickSpec {

    override func spec() {

        let themeConfig = UsabillaThemeConfigurator()
        let pageModel = PageModel(pageNumber: 0, pageName: "test", themeConfig: themeConfig)
        var moodComponentViewModel: MoodComponentViewModel!
        var moodModel: MoodFieldModel!

        beforeSuite {
            moodModel = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 5}"), pageModel: pageModel)
        }

        describe("moodComponentViewModelTests") {

            context("When moodComponentViewModel is initialized with correct model") {

                it("should have all values setup correctly", closure: {
                    moodComponentViewModel = MoodComponentViewModel(model: moodModel)
                    expect(moodComponentViewModel).toNot(beNil())
                    expect(moodComponentViewModel.ratingMode).to(equal(RatingMode.selection))
                    expect(moodComponentViewModel.maxValue).to(equal(5))
                    expect(moodComponentViewModel.selectedImages).to(equal(moodModel.themeConfig.enabledEmoticons))
                    expect(moodComponentViewModel.unselectedImages).to(beNil())
                    expect(moodComponentViewModel.value).to(equal(0))
                })
            }

            context("When moodComponentViewModel is initialized with moodmodel that contains less than 5 emoticons") {
                var moodModelLessThan5Moods: MoodFieldModel!

                it("should have all values setup correctly for 3 moods", closure: {
                    moodModelLessThan5Moods = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 3}"), pageModel: pageModel)

                    moodComponentViewModel = MoodComponentViewModel(model: moodModelLessThan5Moods)
                    expect(moodComponentViewModel.maxValue).to(equal(3))
                    let images = themeConfig.emoticons(size: moodModelLessThan5Moods.points, emoticons: themeConfig.enabledEmoticons)
                    expect(moodComponentViewModel.selectedImages).to(equal(images))
                    expect(moodComponentViewModel.unselectedImages).to(beNil())
                    expect(moodComponentViewModel.value).to(equal(0))
                })
                it("should have all values setup correctly for 2 moods", closure: {
                    moodModelLessThan5Moods = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 2}"), pageModel: pageModel)

                    moodComponentViewModel = MoodComponentViewModel(model: moodModelLessThan5Moods)

                    expect(moodComponentViewModel.maxValue).to(equal(2))
                    let images = themeConfig.emoticons(size: moodModelLessThan5Moods.points, emoticons: themeConfig.enabledEmoticons)
                    expect(moodComponentViewModel.selectedImages).to(equal(images))
                    expect(moodComponentViewModel.unselectedImages).to(beNil())
                    expect(moodComponentViewModel.value).to(equal(0))
                })
            }

            context("When moodComponentViewModel is Correctly setup", {

                it("emoticonValue func should return correct values for different mood sizes", closure: {
                    // init cell
                    moodComponentViewModel = MoodComponentViewModel(model: moodModel)

                    // for 5 moods
                    expect(moodComponentViewModel.emoticonValue(index: 1, maxMoods: 5)).to(equal(1))
                    expect(moodComponentViewModel.emoticonValue(index: 2, maxMoods: 5)).to(equal(2))
                    expect(moodComponentViewModel.emoticonValue(index: 3, maxMoods: 5)).to(equal(3))
                    expect(moodComponentViewModel.emoticonValue(index: 4, maxMoods: 5)).to(equal(4))
                    expect(moodComponentViewModel.emoticonValue(index: 5, maxMoods: 5)).to(equal(5))
                    // for 3 moods
                    expect(moodComponentViewModel.emoticonValue(index: 1, maxMoods: 3)).to(equal(1))
                    expect(moodComponentViewModel.emoticonValue(index: 2, maxMoods: 3)).to(equal(3))
                    expect(moodComponentViewModel.emoticonValue(index: 3, maxMoods: 3)).to(equal(5))
                    // for 2 moods
                    expect(moodComponentViewModel.emoticonValue(index: 1, maxMoods: 2)).to(equal(1))
                    expect(moodComponentViewModel.emoticonValue(index: 2, maxMoods: 2)).to(equal(5))
                    // extreem values
                    expect(moodComponentViewModel.emoticonValue(index: 0, maxMoods: 2)).to(equal(0))
                    expect(moodComponentViewModel.emoticonValue(index: 11111, maxMoods: 2)).to(equal(0))
                })
                it("reverseEmoticonValue func should return correct values for different mood sizes", closure: {
                    // init cell
                    moodComponentViewModel = MoodComponentViewModel(model: moodModel)
                    expect(moodComponentViewModel).toNot(beNil())

                    // for 5 moods
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 1, maxMoods: 5)).to(equal(1))
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 2, maxMoods: 5)).to(equal(2))
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 3, maxMoods: 5)).to(equal(3))
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 4, maxMoods: 5)).to(equal(4))
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 5, maxMoods: 5)).to(equal(5))
                    // for 3 moods
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 1, maxMoods: 3)).to(equal(1))
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 3, maxMoods: 3)).to(equal(2))
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 5, maxMoods: 3)).to(equal(3))
                    // for 2 moods
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 1, maxMoods: 2)).to(equal(1))
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 5, maxMoods: 2)).to(equal(2))
                    // extreem values
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: nil, maxMoods: 2)).to(equal(0))
                    expect(moodComponentViewModel.reverseEmoticonValue(fieldValue: 515151, maxMoods: 2)).to(equal(0))
                })
            })
        }
    }
}
