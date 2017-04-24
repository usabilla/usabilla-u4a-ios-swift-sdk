//
//  CampaignManagerTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaignStoreMock: UBCampaignStoreProtocol {
    var campaigns = [CampaignModel]()

    func getCampaigns(appId: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, _ in
            fulfill(self.campaigns)
        }
    }
    func saveCampaign(campaign: CampaignModel) -> Bool {
        return false
    }
}

class CampaignManagerTests: QuickSpec {

    override func spec() {
        let storeMock = CampaignStoreMock()
        let campaignManager = CampaignManager(campaignStore: storeMock)

        describe("CampaignManagerTests") {
            context("when starting the CampaignManager") {
                beforeEach {
                    EventEngine.campaigns = []
                    storeMock.campaigns = []
                }

                it("should return affect 0 campaigns to the eventEngine when no campaigns") {
                    expect(EventEngine.campaigns.count).to(equal(0))
                    campaignManager.start(appId: "")
                    let campaignModel = CampaignModel(id: "testid", json: JSON.parse(""))
                    expect(campaignModel.maximumDisplays).to(equal(0))
                }

                it("should return affect 1 campaign to the eventEngine when the campaign has not limit display") {
                    expect(EventEngine.campaigns.count).to(equal(0))
                    let campaignModel = CampaignModel(id: "testid", json: JSON.parse(""))
                    expect(campaignModel.maximumDisplays).to(equal(0))
                    storeMock.campaigns = [campaignModel]
                    campaignManager.start(appId: "")
                    expect(EventEngine.campaigns.count).to(equal(1))
                    expect(EventEngine.campaigns.first?.identifier).to(equal("testid"))
                }

                it("should return affect 1 campaigns to the eventEngine when the campaign has a display limit") {
                    expect(EventEngine.campaigns.count).to(equal(0))
                    let campaignModel = CampaignModel(id: "testid", json: JSON.parse(""))
                    let campaignModel2 = CampaignModel(id: "testid2", json: JSON.parse(""))
                    campaignModel.maximumDisplays = 1
                    campaignModel.numberOfTimesTriggered = 1
                    storeMock.campaigns = [campaignModel, campaignModel2]
                    campaignManager.start(appId: "")
                    expect(EventEngine.campaigns.count).to(equal(1))
                    expect(EventEngine.campaigns.first?.identifier).to(equal("testid2"))
                }
            }
        }
    }
}
