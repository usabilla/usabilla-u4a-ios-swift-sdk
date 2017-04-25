//
//  CampaignManagerTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

// swiftlint:disable function_body_length

@testable import UsabillaFeedbackForm

class CampaignStoreMock: UBCampaignStoreProtocol {
    var campaigns = [CampaignModel]()
    var onSaveCalled: ((CampaignModel) -> Void)?
    func getCampaigns(appId: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, _ in
            fulfill(self.campaigns)
        }
    }
}

class CampaignManagerTests: QuickSpec {

    override func spec() {
        let storeMock = CampaignStoreMock()

        describe("CampaignManagerTests") {
            context("When starting the CampaignManager") {
                beforeEach {
                    storeMock.campaigns = []
                }

                it("should return affect 0 campaigns to the eventEngine when no campaigns") {
                    let campaignManager = CampaignManager(campaignStore: storeMock, appId: "test")
                    expect(campaignManager.eventEngine.campaigns.count).to(equal(0))
                }

                it("should return affect 1 campaign to the eventEngine when the campaign has not limit display") {
                    let campaignModel = CampaignModel(id: "testid", json: JSON.parse(""))
                    expect(campaignModel.maximumDisplays).to(equal(0))
                    storeMock.campaigns = [campaignModel]
                    let campaignManager = CampaignManager(campaignStore: storeMock, appId: "test")
                    expect(campaignManager.eventEngine.campaigns.count).to(equal(1))
                    expect(campaignManager.eventEngine.campaigns.first?.identifier).to(equal("testid"))
                }

                it("should return affect 1 campaigns to the eventEngine when the campaign has a display limit") {
                    let campaignModel = CampaignModel(id: "testid", json: JSON.parse(""))
                    let campaignModel2 = CampaignModel(id: "testid2", json: JSON.parse(""))
                    campaignModel.maximumDisplays = 1
                    campaignModel.numberOfTimesTriggered = 1
                    storeMock.campaigns = [campaignModel, campaignModel2]
                    let campaignManager = CampaignManager(campaignStore: storeMock, appId: "test")
                    expect(campaignManager.eventEngine.campaigns.count).to(equal(1))
                    expect(campaignManager.eventEngine.campaigns.first?.identifier).to(equal("testid2"))
                }
            }
        }
    }
}
