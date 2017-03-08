//
//  MoodCellViewTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 08/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class MoodCellViewTests: QuickSpec {

    override func spec() {

        let themeConfig = UsabillaThemeConfigurator()
        let pageModel = PageModel(pageNumber: 0, pageName: "test", themeConfig: themeConfig)
        var moodCellView: MoodCellView!
        var moodModel: MoodFieldModel!

        beforeSuite {
            moodModel = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": \"5\"}"), pageModel: pageModel)
        }

        describe("MoodCellViewTests") {

            context("When MoodCellView is initialized with correct model") {

                it("should have all values setup correctly", closure: {
                    moodCellView = MoodCellView(style: .default, reuseIdentifier: nil)
                    expect(moodCellView).toNot(beNil())
                    expect(moodCellView.moodControl.mode).to(equal(RatingMode.selection))

                    moodCellView.setFeedbackItem(moodModel)
                    expect(moodCellView.moodModel.points).to(equal(5))
                    expect(moodCellView.moodControl.selectedImages).to(equal(moodModel.themeConfig.enabledEmoticons))
                    expect(moodCellView.moodControl.unselectedImages).to(beNil())
                    expect(moodCellView.moodControl.rating).to(beNil())
                })
            }
            
            context("When MoodCellView is initialized with wrong model") {
                
                it("should have nil moodModel", closure: {
                    moodCellView = MoodCellView(style: .default, reuseIdentifier: nil)
                    expect(moodCellView).toNot(beNil())
                    
                    moodCellView.setFeedbackItem(TextFieldModel(json: "", pageModel: pageModel))
                    expect(moodCellView?.moodModel).to(beNil())
                })
            }

            context("When MoodCellView is initialized with moodmodel that contains less than 5 emoticons") {
                var moodModelLessThan5Moods: MoodFieldModel!

                it("should have all values setup correctly for 3 moods", closure: {
                    moodModelLessThan5Moods = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": \"3\"}"), pageModel: pageModel)

                    moodCellView = MoodCellView(style: .default, reuseIdentifier: nil)
                    expect(moodCellView).toNot(beNil())
                    expect(moodCellView.moodControl.mode).to(equal(RatingMode.selection))

                    moodCellView.setFeedbackItem(moodModelLessThan5Moods)
                    expect(moodCellView.moodModel.points).to(equal(3))
                    let images = themeConfig.emoticons(size: moodModelLessThan5Moods.points, emoticons: themeConfig.enabledEmoticons)
                    expect(moodCellView.moodControl.selectedImages).to(equal(images))
                    expect(moodCellView.moodControl.unselectedImages).to(beNil())
                    expect(moodCellView.moodControl.rating).to(beNil())
                })
                it("should have all values setup correctly for 2 moods", closure: {
                    moodModelLessThan5Moods = MoodFieldModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": \"2\"}"), pageModel: pageModel)

                    moodCellView = MoodCellView(style: .default, reuseIdentifier: nil)
                    expect(moodCellView).toNot(beNil())
                    expect(moodCellView.moodControl.mode).to(equal(RatingMode.selection))

                    moodCellView.setFeedbackItem(moodModelLessThan5Moods)
                    expect(moodCellView.moodModel.points).to(equal(2))
                    let images = themeConfig.emoticons(size: moodModelLessThan5Moods.points, emoticons: themeConfig.enabledEmoticons)
                    expect(moodCellView.moodControl.selectedImages).to(equal(images))
                    expect(moodCellView.moodControl.unselectedImages).to(beNil())
                    expect(moodCellView.moodControl.rating).to(beNil())
                })
            }

            context("When MoodCellView is Correctly setup", {

                it("emoticonValue func should return correct values for different mood sizes", closure: {
                    // init cell
                    moodCellView = MoodCellView(style: .default, reuseIdentifier: nil)
                    expect(moodCellView).toNot(beNil())
                    expect(moodCellView.moodControl.mode).to(equal(RatingMode.selection))
                    moodCellView.setFeedbackItem(moodModel)

                    // for 5 moods
                    expect(moodCellView.emoticonValue(index: 1, maxMoods: 5)).to(equal(1))
                    expect(moodCellView.emoticonValue(index: 2, maxMoods: 5)).to(equal(2))
                    expect(moodCellView.emoticonValue(index: 3, maxMoods: 5)).to(equal(3))
                    expect(moodCellView.emoticonValue(index: 4, maxMoods: 5)).to(equal(4))
                    expect(moodCellView.emoticonValue(index: 5, maxMoods: 5)).to(equal(5))
                    // for 3 moods
                    expect(moodCellView.emoticonValue(index: 1, maxMoods: 3)).to(equal(1))
                    expect(moodCellView.emoticonValue(index: 2, maxMoods: 3)).to(equal(3))
                    expect(moodCellView.emoticonValue(index: 3, maxMoods: 3)).to(equal(5))
                    // for 2 moods
                    expect(moodCellView.emoticonValue(index: 1, maxMoods: 2)).to(equal(1))
                    expect(moodCellView.emoticonValue(index: 2, maxMoods: 2)).to(equal(5))
                    // extreem values
                    expect(moodCellView.emoticonValue(index: 0, maxMoods: 2)).to(equal(0))
                    expect(moodCellView.emoticonValue(index: 11111, maxMoods: 2)).to(equal(0))
                })
                it("reverseEmoticonValue func should return correct values for different mood sizes", closure: {
                    // init cell
                    moodCellView = MoodCellView(style: .default, reuseIdentifier: nil)
                    expect(moodCellView).toNot(beNil())
                    expect(moodCellView.moodControl.mode).to(equal(RatingMode.selection))
                    moodCellView.setFeedbackItem(moodModel)

                    // for 5 moods
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 1, maxMoods: 5)).to(equal(1))
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 2, maxMoods: 5)).to(equal(2))
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 3, maxMoods: 5)).to(equal(3))
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 4, maxMoods: 5)).to(equal(4))
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 5, maxMoods: 5)).to(equal(5))
                    // for 3 moods
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 1, maxMoods: 3)).to(equal(1))
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 3, maxMoods: 3)).to(equal(2))
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 5, maxMoods: 3)).to(equal(3))
                    // for 2 moods
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 1, maxMoods: 2)).to(equal(1))
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 5, maxMoods: 2)).to(equal(2))
                    // extreem values
                    expect(moodCellView.reverseEmoticonValue(fieldValue: nil, maxMoods: 2)).to(equal(0))
                    expect(moodCellView.reverseEmoticonValue(fieldValue: 515151, maxMoods: 2)).to(equal(0))
                })
            })
        }
    }
}
