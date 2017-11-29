//
//  CampaignViewModelTests.swift
//  Usabilla
//
//  Created by Adil Bougamza on 27/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

class CampaignViewModelTests: QuickSpec {
    var formJson: JSON!
    var manager: CampaignSubmissionRequestManagerProtocol!
    var campaignModel: CampaignModel!

    override func spec() {
        var campaignViewModel: CampaignViewModel!

        describe("campaignViewModelTests") {

            beforeSuite {
                self.formJson = UBMock.formMock().formJsonString
                self.manager = CampaignSubmissionRequestManagerMock()
            }

            beforeEach {
                self.campaignModel = CampaignModel(id: "", targeting: UBMock.mockTargeting, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .active, createdAt: Date())
            }

            context("When initilized campaignViewModel") {
                it("should not set introPageViewModel & introPresenter when json does not contain start page") {
                    let formModel = FormModel(json: self.formJson!, id: "", screenshot: nil)
                    self.campaignModel.form = formModel

                    expect(self.self.campaignModel).toNot(beNil())
                    campaignViewModel = CampaignViewModel(form: formModel!, manager: self.manager)
                    expect(campaignViewModel).toNot(beNil())
                    expect(campaignViewModel.introPageViewModel).to(beNil())
                    expect(campaignViewModel.introPresenter).to(beNil())
                }
                it("should set introPageViewModel & introPresenter when json contains banner page") {
                    // add start page to json form
                    var dict = self.formJson.dictionaryValue
                    var startDict = [String: Any]()
                    startDict["type"] = "banner"
                    dict["form"]!["pages"].arrayObject!.append(startDict)

                    let formModel = FormModel(json: JSON(dict), id: "", screenshot: nil)
                    self.campaignModel.form = formModel
                    expect(self.campaignModel).toNot(beNil())
                    campaignViewModel = CampaignViewModel(form: formModel!, manager: self.manager)
                    expect(campaignViewModel).toNot(beNil())
                    expect(campaignViewModel.introPageViewModel).toNot(beNil())
                    expect(campaignViewModel.introPresenter).toNot(beNil())
                    expect(campaignViewModel.introPresenter is UBBannerPresenter).to(beTrue())
                }
                it("should set introPageViewModel & introPresenter when json contains start page and is an alert") {
                    // add start page to json form
                    var dict = self.formJson.dictionaryValue
                    var startDict = [String: Any]()
                    startDict["type"] = "banner"
                    startDict["fields"] = []
                    startDict["display"] = "alert"
                    dict["form"]!["pages"].arrayObject!.append(startDict)

                    let formModel = FormModel(json: JSON(dict), id: "", screenshot: nil)
                    self.campaignModel.form = formModel
                    expect(self.campaignModel).toNot(beNil())
                    campaignViewModel = CampaignViewModel(form: formModel!, manager: self.manager)
                    expect(campaignViewModel).toNot(beNil())
                    expect(campaignViewModel.introPageViewModel).toNot(beNil())
                    expect(campaignViewModel.introPresenter is UBAlertPresenter).to(beTrue())
                }
            }

            context("When accessing formViewModel") {
                it("should return a formViewModel with the right data") {
                    let formModel = FormModel(json: self.formJson, id: "", screenshot: nil)
                    self.campaignModel.form = formModel
                    campaignViewModel = CampaignViewModel(form: formModel!, manager: self.manager)
                    let formViewModel = campaignViewModel.formViewModel

                    expect(formViewModel).toNot(beNil())
                    expect(formViewModel.currentPageViewModel.name).to(equal("start"))
                    expect(formViewModel.shouldAddMarginWhenKeyboardIsShown).to(beFalse())
                }
            }

            context("When accessing toastViewModel") {
                beforeEach {
                    let json = UBTestHelper.getJSONFromFile(named: "CampaignForm")
                    let formModel = FormModel(json: json, id: "", screenshot: nil)
                    self.campaignModel.form = formModel
                    campaignViewModel = CampaignViewModel(form: formModel!, manager: self.manager)
                    
                }
                it("should return a toastViewModel with the right data") {
                    var toastViewModel = campaignViewModel.toastPageViewModel
                    expect(toastViewModel).to(beNil())

                    campaignViewModel.introViewDidContinue()
                    toastViewModel = campaignViewModel.toastPageViewModel
                    
                    expect(toastViewModel!).toNot(beNil())
                    expect(toastViewModel!.text).to(equal("Thanks!"))
                }
            }

            context("When there are jump rules in a campaign") {
                beforeEach {
                    let json = UBTestHelper.getJSONFromFile(named: "CampaignFormJumpRules")
                    let formModel = FormModel(json: json, id: "", screenshot: nil)
                    self.campaignModel.form = formModel
                    campaignViewModel = CampaignViewModel(form: formModel!, manager: self.manager)

                }
                it("should go to the correct page when the mood is 1") {
                    expect(campaignViewModel.formViewModel.currentPageIndex).to(equal(0))
                    let moodField = campaignViewModel.formViewModel.model.pages[0].fields.first as! MoodFieldModel
                    moodField.fieldValue = 1
                    expect(campaignViewModel.currentPageType).to(equal(PageType.banner))
                    campaignViewModel.introViewDidContinue()
                    expect(campaignViewModel.formViewModel.currentPageIndex).to(equal(1))
                    expect(campaignViewModel.formViewModel.currentPageViewModel.name).to(equal("Negative"))
                    expect(campaignViewModel.currentPageType).to(equal(PageType.form))
                    campaignViewModel.formViewModel.currentPageViewModel = campaignViewModel.pageViewModel(atIndex: campaignViewModel.formViewModel.nextPageIndex)
                    expect(campaignViewModel.formViewModel.currentPageIndex).to(equal(3))
                    expect(campaignViewModel.formViewModel.currentPageViewModel.name).to(equal("End2"))
                    expect(campaignViewModel.currentPageType).to(equal(PageType.toast))

                }
                it("should go to the correct page when the mood is 5") {
                    expect(campaignViewModel.formViewModel.currentPageIndex).to(equal(0))
                    let moodField = campaignViewModel.formViewModel.model.pages[0].fields.first as! MoodFieldModel
                    let moodViewModel = campaignViewModel.formViewModel.pageViewModel(atIndex: 0).cellViewModels.first { $0.model is MoodFieldModel }
                    moodField.fieldValue = 5
                    moodViewModel?.valueDidChange()
                    expect(campaignViewModel.currentPageType).to(equal(PageType.banner))
                    campaignViewModel.introViewDidContinue()
                    expect(campaignViewModel.formViewModel.currentPageIndex).to(equal(2))
                    expect(campaignViewModel.formViewModel.currentPageViewModel.name).to(equal("end"))
                    expect(campaignViewModel.currentPageType).to(equal(PageType.toast))
                }
            }
        }
    }
}
