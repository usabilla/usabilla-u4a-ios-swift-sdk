//
//  IntroPageViewModelTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 24/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length
// swiftlint:disable force_cast

import Quick
import Nimble

@testable import Usabilla

class IntroPageViewModelTests: QuickSpec {

    override func spec() {
        var configurator = UsabillaTheme()
        configurator.colors.background = UIColor(rgba: "#012345")
        configurator.colors.title = UIColor(rgba: "#012346")
        configurator.colors.text = UIColor(rgba: "#012347")

        let introPage = IntroPageModel(pageName: "test", type: .form)
        let copyModel = CopyModel()
        beforeEach {
            let moodField = MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"Hello\"}"), pageModel: introPage)
            introPage.fields = [moodField]
            introPage.copy = copyModel
            copyModel.introCancelButton = "canceltest"

        }

        describe("IntroPageViewModel") {
            context("when initialized with a page a paragraph field") {
                it("should not set the component view model when the paragraph is empty") {
                    let paragraphField = ParagraphFieldModel(json: JSON(parseJSON: "{\"text\":\"\"}"), pageModel: introPage)
                    let introPage = IntroPageModel(pageName: "test", type: .banner)
                    introPage.fields = [paragraphField]

                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)

                    expect(introPageViewModel.componentViewModel).to(beNil())
                }
                it("should set the component view model when the paragraph has a text") {
                    let paragraphField = ParagraphFieldModel(json: JSON(parseJSON: "{\"text\":\"hello\"}"), pageModel: introPage)
                    let introPage = IntroPageModel(pageName: "test", type: .banner)
                    introPage.fields = [paragraphField]
                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)
                    expect(introPageViewModel.componentViewModel).toNot(beNil())
                    let viewModel = introPageViewModel.componentViewModel as! ParagraphComponentViewModel
                    expect(viewModel.value).to(equal("hello"))
                }
            }
            context("when using default font") {
                it("customization should match") {
                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)
                    expect(introPageViewModel.backgroundColor).to(equal(configurator.colors.background))
                    expect(introPageViewModel.titleColor).to(equal(configurator.colors.title))
                    expect(introPageViewModel.hintColor).to(equal(configurator.colors.hint))
                    expect(introPageViewModel.barButtonItemColor).to(equal(configurator.colors.textOnAccent))
                    expect(introPageViewModel.font).to(equal(configurator.fonts.font))
                    expect(introPageViewModel.boldFont).to(equal(configurator.fonts.boldFont))
                    expect(introPageViewModel.buttonColor).to(equal(configurator.colors.accent))
                }
            }

            context("when using custom font") {
                it("cancel and continue label font should be customized") {
                    let customFont = UIFont(name: "TimesNewRomanPSMT", size: 17)
                    configurator.fonts.regular = customFont
                    let customFontBold = UIFont(name: "TimesNewRomanPS-BoldMT", size: 17)
                    configurator.fonts.bold = customFontBold
                    let introPage = IntroPageModel(pageName: "test", type: .banner)
                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)

                    expect(introPageViewModel.font).to(equal(customFont))
                    expect(introPageViewModel.boldFont).to(equal(customFontBold))
                }
            }

            context("when it is banner with mood component") {
                it("viewModel attributes should match") {
                    let introPage2 = IntroPageModel(pageName: "test", type: .banner)
                    let copy2 = CopyModel()
                    copy2.introCancelButton = "canceltest"
                    introPage2.copy = copy2
                    introPage2.fields = [MoodFieldModel(json: JSON(parseJSON: "{\"title\":\"Hello\"}"), pageModel: introPage2)]
                    let introPageViewModel2 = IntroPageViewModel(introPage: introPage2, theme: configurator)
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
                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)
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
                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)
                    expect(introPageViewModel.componentViewModel).to(beNil())
                }
            }

            context("when there is a mood component that is required") {
                beforeEach {
                    introPage.fields.first?.required = true
                }
                it("viewModel canContinue property should be false") {
                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)
                    expect(introPageViewModel.canContinue).to(beFalse())
                }

                it("viewModel canContinue property should be true when mood value is set") {
                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)
                    // swiftlint:disable force_cast
                    (introPage.fields.first as! MoodFieldModel).fieldValue = 2
                    expect(introPageViewModel.canContinue).to(beTrue())
                }
            }

            context("when there is a mood component that is not required") {
                beforeEach {
                    introPage.fields.first?.required = false
                }
                it("viewModel canContinue property should be true") {
                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)
                    expect(introPageViewModel.canContinue).to(beTrue())
                }
                it("viewModel canContinue property should be true when mood value is set") {
                    let introPageViewModel = IntroPageViewModel(introPage: introPage, theme: configurator)
                    // swiftlint:disable force_cast
                    (introPage.fields.first as! MoodFieldModel).fieldValue = 2
                    expect(introPageViewModel.canContinue).to(beTrue())
                }
            }
        }
    }
}
