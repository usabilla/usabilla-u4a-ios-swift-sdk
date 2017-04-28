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
                    let campaignModel = CampaignModel(id: "testid", json: JSON.parse("{\"targeting_options_id\" : \"tid\"}"))
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

            context("When sending event the CampaignManager") {
                beforeEach {
                    storeMock.campaigns = []
                    storeMock.onSaveCalled = nil
                    UBCampaignDAO.shared.deleteAll()
                    CampaignWindow.shared.campaignDidEnd(success: false)
                    UsabillaFeedbackForm.canDisplayCampaigns = true
                }
                it("should save campaigns when there are responding campaigns for the event") {
                    let leaf = LeafRule(event: Event(name: "foo"))
                    let leaf2 = LeafRule(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf, leaf2])

                    let campaigns = [
                        CampaignModel(id: "a", rule: rule, formId: "", targetingId: "", maximumDisplays: 0, version: 0),
                        CampaignModel(id: "b", json: JSON.parse(""))
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }

                    storeMock.campaigns = campaigns
                    let campaignManager = CampaignManager(campaignStore: storeMock, appId: "test")
                    var triggeredRule = UBCampaignDAO.shared.read(id: "a")?.rule?.childRules.first as? LeafRule
                    expect(triggeredRule?.event.name).to(equal("foo"))
                    expect(triggeredRule?.alreadyTriggered).to(beFalse())
                    campaignManager.sendEvent(event: "foo")
                    triggeredRule = UBCampaignDAO.shared.read(id: "a")?.rule?.childRules.first as? LeafRule
                    expect(triggeredRule?.event.name).to(equal("foo"))
                    expect(triggeredRule?.alreadyTriggered).to(beTrue())
                }
                it("should not display campaign that have not triggered") {
                    let leaf = LeafRule(event: Event(name: "foo"))
                    let leaf2 = LeafRule(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf, leaf2])

                    let campaigns = [
                        CampaignModel(id: "a", rule: rule, formId: "", targetingId: "", maximumDisplays: 0, version: 0),
                        CampaignModel(id: "b", json: JSON.parse(""))
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }

                    let campaignManager = CampaignManager(campaignStore: storeMock, appId: "test")
                    var campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "foo")
                    campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(0))
                }
                it("should display campaign that triggered") {
                    let leaf = LeafRule(event: Event(name: "foo"))
                    let leaf2 = LeafRule(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf, leaf2])

                    let campaigns = [
                        CampaignModel(id: "a", rule: rule, formId: "", targetingId: "", maximumDisplays: 0, version: 0),
                        CampaignModel(id: "b", json: JSON.parse(""))
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }

                    storeMock.campaigns = campaigns

                    let campaignManager = CampaignManager(campaignStore: storeMock, appId: "test")
                    var campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "foo")
                    campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "bar")
                    campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(1))
                }
                it("should display only the first campaign that triggered") {
                    let leaf = LeafRule(event: Event(name: "foo"))
                    let leaf2 = LeafRule(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf, leaf2])

                    let campaigns = [
                        CampaignModel(id: "a", rule: rule, formId: "", targetingId: "", maximumDisplays: 0, version: 0),
                        CampaignModel(id: "b", rule: rule, formId: "", targetingId: "", maximumDisplays: 0, version: 0)
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }
                    storeMock.campaigns = campaigns

                    let campaignManager = CampaignManager(campaignStore: storeMock, appId: "test")
                    var campaignA = UBCampaignDAO.shared.read(id: "a")
                    var campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "foo")
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "bar")
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(1))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                }
                it("should display campaign if the semaphore allow it and the campaign can be displayed again") {
                    let leaf = LeafRule(event: Event(name: "foo"))
                    let leaf2 = LeafRule(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf, leaf2])

                    let campaigns = [
                        CampaignModel(id: "a", rule: rule, formId: "", targetingId: "", maximumDisplays: 0, version: 0)
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }

                    storeMock.campaigns = campaigns

                    let campaignManager = CampaignManager(campaignStore: storeMock, appId: "test")
                    var campaignA = UBCampaignDAO.shared.read(id: "a")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))

                    UsabillaFeedbackForm.canDisplayCampaigns = false
                    campaignManager.displayCampaign(campaignA!)
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))

                    UsabillaFeedbackForm.canDisplayCampaigns = true
                    campaignA?.maximumDisplays = 1
                    campaignA?.numberOfTimesTriggered = 1
                    campaignManager.displayCampaign(campaignA!)
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))

                    campaignA?.numberOfTimesTriggered = 0
                    campaignManager.displayCampaign(campaignA!)
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(1))
                }
            }
        }
    }
}
