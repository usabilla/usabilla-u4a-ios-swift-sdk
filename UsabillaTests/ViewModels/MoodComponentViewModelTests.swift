//
//  MoodComponentViewModelTests.swift
//  Usabilla
//
//  Created by Adil Bougamza on 08/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Foundation

import Quick
import Nimble

@testable import Usabilla

class MoodComponentViewModelTests: QuickSpec {

    override func spec() {

        let theme = UsabillaTheme()
        var moodComponentViewModel: MoodComponentViewModel!
        var moodModel: MoodFieldModel!
        var starMoodModel: MoodFieldModel!

        beforeSuite {
            moodModel = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 5}"))
            starMoodModel = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 5, \"mode\": \"star\"}"))
        }

        describe("moodComponentViewModelTests") {
            context("When updating value") {
                it("should notify the delegate") {
                    moodComponentViewModel = MoodComponentViewModel(model: moodModel, theme: theme)
                    let delegate = MockBaseComponentViewModelDelegate()
                    moodComponentViewModel.delegate = delegate
                    waitUntil(timeout: 1.0) { done in
                        delegate.onValueDidChange = done
                        moodComponentViewModel.value = nil
                    }
                }
            }
            context("When moodComponentViewModel is initialized with correct model") {
                it("should have all values setup correctly for Emoticone mode", closure: {
                    moodComponentViewModel = MoodComponentViewModel(model: moodModel, theme: theme)
                    expect(moodComponentViewModel).toNot(beNil())
                    expect(moodComponentViewModel.ratingMode).to(equal(RatingMode.emoticon))
                    expect(moodComponentViewModel.maxValue).to(equal(5))
                    expect(moodComponentViewModel.selectedImages).to(equal(theme.images.enabledEmoticons))
                    expect(moodComponentViewModel.unselectedImages).to(beNil())
                    expect(moodComponentViewModel.value).to(equal(0))
                    expect(moodComponentViewModel.tintColor).to(equal(theme.colors.accent))
                })
                it("should have all values setup correctly for Star mode", closure: {
                    moodComponentViewModel = MoodComponentViewModel(model: starMoodModel, theme: theme)
                    expect(moodComponentViewModel).toNot(beNil())
                    expect(moodComponentViewModel.ratingMode).to(equal(RatingMode.star))
                    expect(moodComponentViewModel.maxValue).to(equal(5))
                    expect(moodComponentViewModel.selectedImages!.count).to(equal(1))
                    expect(moodComponentViewModel.unselectedImages!.count).to(equal(1))
                    expect(moodComponentViewModel.value).to(equal(0))
                })
            }

            context("When moodComponentViewModel is initialized with moodmodel that contains less than 5 emoticons") {
                var moodModelLessThan5Moods: MoodFieldModel!

                it("should have all values setup correctly for 3 moods", closure: {
                    moodModelLessThan5Moods = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 3}"))

                    moodComponentViewModel = MoodComponentViewModel(model: moodModelLessThan5Moods, theme: theme)
                    expect(moodComponentViewModel.maxValue).to(equal(3))
                    let images = theme.emoticons(size: moodModelLessThan5Moods.points, emoticons: theme.images.enabledEmoticons)
                    expect(moodComponentViewModel.selectedImages).to(equal(images))
                    expect(moodComponentViewModel.unselectedImages).to(beNil())
                    expect(moodComponentViewModel.value).to(equal(0))
                })
                it("should have all values setup correctly for 2 moods", closure: {
                    moodModelLessThan5Moods = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 2}"))

                    moodComponentViewModel = MoodComponentViewModel(model: moodModelLessThan5Moods, theme: theme)

                    expect(moodComponentViewModel.maxValue).to(equal(2))
                    let images = theme.emoticons(size: moodModelLessThan5Moods.points, emoticons: theme.images.enabledEmoticons)
                    expect(moodComponentViewModel.selectedImages).to(equal(images))
                    expect(moodComponentViewModel.unselectedImages).to(beNil())
                    expect(moodComponentViewModel.value).to(equal(0))
                })
            }

            context("When moodComponentViewModel is Correctly setup", {

                it("emoticonValue func should return correct values for different mood sizes", closure: {
                    // init cell
                    moodComponentViewModel = MoodComponentViewModel(model: moodModel, theme: theme)

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
                    moodComponentViewModel = MoodComponentViewModel(model: moodModel, theme: theme)
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

            context("When mood component is correctly setup") {
                it("should return correct values for accessibility labels when count is 2") {
                    let modelFor2 = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 2}"))
                    moodComponentViewModel = MoodComponentViewModel(model: modelFor2, theme: theme)
                    let labels = moodComponentViewModel.accessibilityLabels
                    expect(labels.count).to(equal(2))
                    expect(labels[0]).to(equal(UBAccessibility.emoticonLabels[0]))
                    expect(labels[1]).to(equal(UBAccessibility.emoticonLabels[4]))
                }
                it("should return correct values for accessibility labels when count is 3") {
                    let modelFor3 = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 3}"))
                    moodComponentViewModel = MoodComponentViewModel(model: modelFor3, theme: theme)
                    let labels = moodComponentViewModel.accessibilityLabels
                    expect(labels.count).to(equal(3))
                    expect(labels[0]).to(equal(UBAccessibility.emoticonLabels[0]))
                    expect(labels[1]).to(equal(UBAccessibility.emoticonLabels[2]))
                    expect(labels[2]).to(equal(UBAccessibility.emoticonLabels[4]))
                }
                it("should return correct values for accessibility labels when count is 5") {
                    let modelFor5 = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"test\", \"name\": \"myField\", \"placeholder\": \"myplaceholder\", \"points\": 5}"))
                    moodComponentViewModel = MoodComponentViewModel(model: modelFor5, theme: theme)
                    let labels = moodComponentViewModel.accessibilityLabels
                    expect(labels.count).to(equal(5))
                    expect(labels[0]).to(equal(UBAccessibility.emoticonLabels[0]))
                    expect(labels[1]).to(equal(UBAccessibility.emoticonLabels[1]))
                    expect(labels[2]).to(equal(UBAccessibility.emoticonLabels[2]))
                    expect(labels[3]).to(equal(UBAccessibility.emoticonLabels[3]))
                    expect(labels[4]).to(equal(UBAccessibility.emoticonLabels[4]))
                }
                it("should return correct values for accessibility labels in Star mode") {
                    moodComponentViewModel = MoodComponentViewModel(model: starMoodModel, theme: theme)
                    let labels = moodComponentViewModel.accessibilityLabels
                    expect(labels.count).to(equal(5))
                    expect(labels[0]).to(equal(UBAccessibility.starLabels[0]))
                    expect(labels[1]).to(equal(UBAccessibility.starLabels[1]))
                    expect(labels[2]).to(equal(UBAccessibility.starLabels[2]))
                    expect(labels[3]).to(equal(UBAccessibility.starLabels[3]))
                    expect(labels[4]).to(equal(UBAccessibility.starLabels[4]))
                }
            }
        }
    }
}
