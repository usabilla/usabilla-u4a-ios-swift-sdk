//
//  IntroPageViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class IntroPageViewModelTests: QuickSpec {

    override func spec() {
        var configurator = UsabillaTheme()
        configurator.backgroundColor = UIColor(rgba: "#012345")
        configurator.titleColor = UIColor(rgba: "#012346")
        configurator.textColor = UIColor(rgba: "#012347")

        let introPage = IntroPageModel(pageNumber: 0, pageName: "test", theme: configurator)
        let copyModel = CopyModel()
        beforeSuite {
            let moodField = MoodFieldModel(json: JSON.parse("{\"title\":\"Hello\"}"), pageModel: introPage)
            introPage.fields = [moodField]
            introPage.copy = copyModel
            copyModel.introCancelButton = "canceltest"

        }

        describe("IntroPageViewModel") {
            context("when using default font") {
                it("customization should match") {
                    let introPageViewModel = IntroPageViewModel(introPage: introPage)
                    expect(introPageViewModel.backgroundColor).to(equal(configurator.backgroundColor))
                    expect(introPageViewModel.titleColor).to(equal(configurator.titleColor))
                    expect(introPageViewModel.hintColor).to(equal(configurator.hintColor))
                    expect(introPageViewModel.font).to(equal(UIFont.systemFont(ofSize: 17)))
                    expect(introPageViewModel.boldFont).to(equal(UIFont.systemFont(ofSize: 17)))
                    expect(introPageViewModel.buttonColor).to(equal(configurator.accentColor))
                }
            }

            context("when using custom font") {
                it("cancel and continue label font should be customized") {
                    let customFont = UIFont(name: "TimesNewRomanPSMT", size: 17)
                    configurator.customFont = customFont
                    let customFontBold = UIFont(name: "TimesNewRomanPS-BoldMT", size: 17)
                    configurator.customFontBold = customFontBold
                    let introPage = IntroPageModel(pageNumber: 0, pageName: "test", theme: configurator)
                    let introPageViewModel = IntroPageViewModel(introPage: introPage)

                    expect(introPageViewModel.font).to(equal(customFont))
                    expect(introPageViewModel.boldFont).to(equal(customFontBold))
                }
            }

            context("when it is banner with mood component") {
                it("viewModel attributes should match") {
                    let introPage2 = IntroPageModel(pageNumber: 0, pageName: "test", theme: configurator)
                    let copy2 = CopyModel()
                    copy2.introCancelButton = "canceltest"
                    introPage2.copy = copy2
                    introPage2.fields = [MoodFieldModel(json: JSON.parse("{\"title\":\"Hello\"}"), pageModel: introPage2)]
                    let introPageViewModel2 = IntroPageViewModel(introPage: introPage2)
                    expect(introPageViewModel2.displayMode).to(equal(IntroPageDisplayMode.bannerBottom))
                    expect(introPageViewModel2.title).to(equal("Hello"))
                    expect(introPageViewModel2.cancelLabelText).to(equal("canceltest"))
                    expect(introPageViewModel2.hasContinueButton).to(beFalse())
                    expect(introPageViewModel2.continueLabelText).to(beNil())
                }
            }

            context("when it is alert with mood and a continue button") {
                it("viewModel attributes should match") {
                    copyModel.introContinueButton = "continuetest"
                    introPage.hasContinueButton = true
                    introPage.displayMode = .alert
                    let introPageViewModel = IntroPageViewModel(introPage: introPage)
                    expect(introPageViewModel.displayMode).to(equal(IntroPageDisplayMode.alert))
                    expect(introPageViewModel.title).to(equal("Hello"))
                    expect(introPageViewModel.cancelLabelText).to(equal("canceltest"))
                    expect(introPageViewModel.hasContinueButton).to(beTrue())
                    expect(introPageViewModel.continueLabelText).to(equal("continuetest"))
                }
            }

            context("when there is no component") {
                it("viewModel should have no componentViewModel") {
                    introPage.fields = []
                    let introPageViewModel = IntroPageViewModel(introPage: introPage)
                    expect(introPageViewModel.componentViewModel).to(beNil())
                }
            }
        }
    }
}
