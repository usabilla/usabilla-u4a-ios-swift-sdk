//
//  CampainViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 27/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaingViewModelTests: QuickSpec {
    var formJson: JSON!
    var manager: CampaignSubmissionRequestManagerProtocol!

    override func spec() {
        describe("CampainViewModelTests") {

            beforeSuite {
                self.formJson = UBMock.formMock().formJsonString
                self.manager = CampaignSubmissionRequestManagerMock()
            }

            context("When initilized CampainViewModel", {
                it("should not set introPageViewModel & introPresenter when json does not conatin start page", closure: {
                    let campaign = CampaignModel(id: "id", json: JSON.parse(""))
                    let formModel = FormModel(json: self.formJson!, id: "", screenshot: nil)
                    campaign.form = formModel

                    expect(campaign).toNot(beNil())
                    let campainViewModel = CampaignViewModel(form: formModel, manager: self.manager)
                    expect(campainViewModel).toNot(beNil())
                    expect(campainViewModel.introPageViewModel).to(beNil())
                    expect(campainViewModel.introPresenter).to(beNil())
                })
                it("should set introPageViewModel & introPresenter when json contains start page", closure: {
                    // add start page to json form
                    var dict = self.formJson.dictionaryValue
                    var startDict = [String: Any]()
                    startDict["type"] = "start"
                    dict["form"]!["pages"].arrayObject!.append(startDict)

                    let campaign = CampaignModel(id: "id", json: JSON.parse(""))

                    let formModel = FormModel(json: JSON(dict), id: "", screenshot: nil)
                    campaign.form = formModel
                    expect(campaign).toNot(beNil())
                    let campainViewModel = CampaignViewModel(form: formModel, manager: self.manager)
                    expect(campainViewModel).toNot(beNil())
                    expect(campainViewModel.introPageViewModel).toNot(beNil())
                    expect(campainViewModel.introPresenter).toNot(beNil())
                    expect(campainViewModel.introPresenter is UBBannerPresenter).to(beTrue())

                })
                it("should set introPageViewModel & introPresenter when json contains start page and is an alert", closure: {
                    // add start page to json form
                    var dict = self.formJson.dictionaryValue
                    var startDict = [String: Any]()
                    startDict["type"] = "start"
                    startDict["fields"] = []
                    startDict["display"] = "alert"
                    dict["form"]!["pages"].arrayObject!.append(startDict)

                    let campaign = CampaignModel(id: "id", json: JSON.parse(""))
                    let formModel = FormModel(json: JSON(dict), id: "", screenshot: nil)
                    campaign.form = formModel
                    expect(campaign).toNot(beNil())
                    let campainViewModel = CampaignViewModel(form: formModel, manager: self.manager)
                    expect(campainViewModel).toNot(beNil())
                    expect(campainViewModel.introPageViewModel).toNot(beNil())
                    expect(campainViewModel.introPresenter is UBAlertPresenter).to(beTrue())
                })
            })

            context("When accessing formViewModel", {
                it("should return a formViewModel with the right data", closure: {
                    let campaign = CampaignModel(id: "id", json: JSON.parse(""))
                    let formModel = FormModel(json: self.formJson, id: "", screenshot: nil)
                    campaign.form = formModel
                    let campainViewModel = CampaignViewModel(form: formModel, manager: self.manager)
                    let formViewModel = campainViewModel.formViewModel

                    expect(formViewModel).toNot(beNil())
                    expect(formViewModel.currentPageViewModel.name).to(equal("Third"))
                    expect(formViewModel.shouldAddMarginWhenKeyboardIsShown).to(beFalse())
                })
            })

            context("When accessing toastViewModel", {
                it("should return a toastViewModel with the right data", closure: {

                    let path = Bundle(for: CampaingViewModelTests.self).path(forResource: "CampaignForm", ofType: "json")!
                    let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                    let json = JSON(data: (data as Data?)!)

                    let campaign = CampaignModel(id: "id", json: JSON.parse(""))
                    let formModel = FormModel(json: json, id: "", screenshot: nil)
                    campaign.form = formModel
                    let campainViewModel = CampaignViewModel(form: formModel)
                    let toastViewModel = campainViewModel.toastPageViewModel

                    expect(toastViewModel!).toNot(beNil())
                    expect(toastViewModel!.text).to(equal("Thanks!"))
                })
            })
        }
    }
}
