//
//  CampainViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 27/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaingViewModelTests: QuickSpec {
    var formJson: JSON!

    override func spec() {
        describe("CampainViewModelTests") {

            beforeSuite {
                let path = Bundle(for: CampaingViewModelTests.self).path(forResource: "test", ofType: "json")!
                do {
                    let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                    self.formJson = JSON(data: data as Data)
                } catch let error as NSError {
                    Swift.debugPrint(error.localizedDescription)
                }
            }

            context("When initilized CampainViewModel", {
                it("should not set introPageViewModel & introPresenter when json does not conatin start page", closure: {
                    let campaign = CampaignModel(id: "id", json: JSON.parse(""))
                    let formModel = FormModel(json: self.formJson!, id: "", screenshot: nil)
                    campaign.form = formModel

                    expect(campaign).toNot(beNil())
                    let campainViewModel = CampaignViewModel(campaign: campaign)
                    expect(campainViewModel).toNot(beNil())
                    expect(campainViewModel.introPageViewModel).to(beNil())
                    expect(campainViewModel.introPresenter).to(beNil())
                })
                it("should set introPageViewModel & introPresenter when json conatins start page", closure: {
                    // add start page to json form
                    var dict = self.formJson.dictionaryValue
                    var startDict = [String: Any]()
                    startDict["type"] = "start"
                    startDict["fileds"] = []
                    dict["form"]!["pages"].arrayObject!.append(startDict)
                    self.formJson = JSON(dict)

                    let campaign = CampaignModel(id: "id", json: JSON.parse(""))
                    let formModel = UBMock.formMock()
                    campaign.form = formModel
                    expect(campaign).toNot(beNil())
                    let campainViewModel = CampaignViewModel(campaign: campaign)
                    expect(campainViewModel).toNot(beNil())
                    expect(campainViewModel.introPageViewModel).toNot(beNil())
                    expect(campainViewModel.introPresenter).toNot(beNil())
                })
            })
        }
    }
}
