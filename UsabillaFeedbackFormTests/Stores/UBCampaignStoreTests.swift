//
//  UBCampaignStoreTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 14/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBCampaignStoreTests: QuickSpec {

    override func spec() {
        describe("UBCampaignStoreTests") {
            let store = UBCampaignStore()
            context("When saving a campaigns") {
                it("should persist it correctly") {
                    // Remove data
                    UBCampaignDAO.shared.deleteAll()
                    expect(UBCampaignDAO.shared.readAll().count).to(equal(0))

                    // Create campaign
                    let campaign = UBMock.campaignMock()
                    let isSaved = store.saveCampaign(campaign: campaign)
                    expect(isSaved).to(beTrue())

                    let allCampaigns = UBCampaignDAO.shared.readAll()
                    expect(allCampaigns.count).to(equal(1))
                    expect(allCampaigns.first!.identifier).to(equal(campaign.identifier))
                }
            }

            context("When fetching campaigns") {
                it("should return the correct data") {
                    // Remove data
                    UBCampaignDAO.shared.deleteAll()
                    expect(UBCampaignDAO.shared.readAll().count).to(equal(0))

                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(appId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(0))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }

                    // Create campaign
                    let campaign = UBMock.campaignMock()
                    store.saveCampaign(campaign: campaign)

                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(appId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(1))
                            expect(campaigns.first!.identifier).to(equal(campaign.identifier))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            }
        }
    }
}
