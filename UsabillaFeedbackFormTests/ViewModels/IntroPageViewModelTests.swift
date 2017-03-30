//
//  IntroPageViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class IntroPageViewModelTests: QuickSpec {

    override func spec() {
        let configurator = UsabillaThemeConfigurator()
        let introPage = IntroPageModel(pageNumber: 0, pageName: "test", themeConfig: configurator)
        let copyModel = CopyModel()
        beforeSuite {
            let moodField = MoodFieldModel(json: JSON.parse("{\"title\":\"Hello\"}"), pageModel: introPage)
            introPage.fields = [moodField]
            introPage.copy = copyModel
            copyModel.introCancelButton = "canceltest"
            configurator.backgroundColor = UIColor(rgba: "#012345")
            configurator.titleColor = UIColor(rgba: "#012346")
            configurator.textColor = UIColor(rgba: "#012347")
        }

        describe("IntroPageViewModel") {
            context("when using default font") {
                it("customization should match") {
                    let introPageViewModel = IntroPageViewModel(introPage: introPage)
                    expect(introPageViewModel.backgroundColor).to(equal(configurator.backgroundColor))
                    expect(introPageViewModel.titleColor).to(equal(configurator.titleColor))
                    expect(introPageViewModel.hintColor).to(equal(configurator.hintColor))
                    expect(introPageViewModel.cancelButtonFont).to(equal(UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)))
                    expect(introPageViewModel.continueButtonFont).to(equal(UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)))
                    expect(introPageViewModel.buttonsColor).to(equal(UIColor.blue))
                }
            }

            context("when using custom font") {
                it("cancel and continue label font should be customized") {
                    let introPageViewModel = IntroPageViewModel(introPage: introPage)
                    let customFont = UIFont(name: "TimesNewRomanPSMT", size: 17)
                    configurator.customFont = customFont
                    let customFontBold = UIFont(name: "TimesNewRomanPS-BoldMT", size: 17)
                    configurator.customFontBold = customFontBold

                    expect(introPageViewModel.cancelButtonFont).to(equal(customFont))
                    expect(introPageViewModel.continueButtonFont).to(equal(customFontBold))
                }
            }

            context("when it is banner with mood component") {
                it("viewModel attributes should match") {
                    let introPageViewModel = IntroPageViewModel(introPage: introPage)
                    expect(introPageViewModel.displayMode).to(equal(IntroPageDisplayMode.bannerBottom))
                    expect(introPageViewModel.title).to(equal("Hello"))
                    expect(introPageViewModel.cancelLabelText).to(equal("canceltest"))
                    expect(introPageViewModel.hasContinueButton).to(beFalse())
                    expect(introPageViewModel.continueLabelText).to(beNil())
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
