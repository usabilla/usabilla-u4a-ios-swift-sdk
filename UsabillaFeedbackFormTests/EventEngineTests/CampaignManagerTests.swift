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
    var form: FormModel?
    var getCampaignFormHasBeenCalled: Bool = false
    func getCampaigns(withAppId appId: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, _ in
            fulfill(self.campaigns)
        }
    }

    func getCampaignForm(withFormId formId: String, theme: UsabillaTheme) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            getCampaignFormHasBeenCalled = true
            if let form = self.form {
                return fulfill(form)
            }
            reject(NSError(domain: "", code: 0, userInfo: nil))
        }
    }
}

class CampaignManagerTests: QuickSpec {

    override func spec() {
        let storeMock = CampaignStoreMock()
        let manager = CampaignSubmissionRequestManagerMock()
        var campaignServiceMock: UBCampaignServiceMock!
        let activeStatuses: [String: String] = [String: String]()
        
        describe("CampaignManagerTests") {
            context("When starting the CampaignManager") {
                beforeEach {
                    storeMock.campaigns = []
                    campaignServiceMock = UBCampaignServiceMock()
                }

                it("should return affect 0 campaigns to the eventEngine when no campaigns") {
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
                    expect(campaignManager.eventEngine.campaigns.count).to(equal(0))
                }
                it("should return affect 1 campaign to the eventEngine when the campaign has not limit display") {
                    let campaignModel = UBMock.campaignMock(withId: "testid")
                    expect(campaignModel.maximumDisplays).to(equal(0))
                    storeMock.campaigns = [campaignModel]
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
                    expect(campaignManager.eventEngine.campaigns.count).to(equal(1))
                    expect(campaignManager.eventEngine.campaigns.first?.identifier).to(equal("testid"))
                }
                it("should return affect 1 campaigns to the eventEngine when the campaign is not active") {
                    let campaignModel = UBMock.campaignMock(withId: "testid")
                    let campaignModel2 = UBMock.campaignMock(withId: "testid2")
                    campaignModel.status = .inactive
                    storeMock.campaigns = [campaignModel, campaignModel2]
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
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
                    let campaigns = [
                        UBMock.campaignMockWithRules(id: "a"),
                        UBMock.campaignMock(withId: "b")
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }

                    storeMock.campaigns = campaigns
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
                    var triggeredRule = UBCampaignDAO.shared.read(id: "a")?.rule?.childRules.first as? LeafEvent
                    expect(triggeredRule?.event.name).to(equal("foo"))
                    expect(triggeredRule?.alreadyTriggered).to(beFalse())
                    campaignManager.sendEvent(event: "foo", activeStatuses: activeStatuses)
                    triggeredRule = UBCampaignDAO.shared.read(id: "a")?.rule?.childRules.first as? LeafEvent
                    expect(triggeredRule?.event.name).to(equal("foo"))
                    expect(triggeredRule?.alreadyTriggered).to(beTrue())
                }
                it("should not display campaign that have not triggered") {
                    let campaigns = [
                        UBMock.campaignMockWithRules(id: "a"),
                        UBMock.campaignMock(withId: "b")
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }

                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
                    var campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "foo", activeStatuses: activeStatuses)
                    campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(0))
                }
                it("should display campaign that triggered") {
                    let campaigns = [
                        UBMock.campaignMockWithRules(id: "a"),
                        UBMock.campaignMock(withId: "b")
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }

                    storeMock.campaigns = campaigns
                    storeMock.form = UBMock.formMock()
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
                    var campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "foo", activeStatuses: activeStatuses)
                    campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "bar", activeStatuses: activeStatuses)
                    campaign = UBCampaignDAO.shared.read(id: "a")
                    expect(campaign?.numberOfTimesTriggered).to(equal(1))
                }
                it("should display only the first campaign that triggered") {
                    let campaigns = [
                        UBMock.campaignMockWithRules(id: "a"),
                        UBMock.campaignMockWithRules(id: "b")
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }
                    storeMock.campaigns = campaigns

                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
                    var campaignA = UBCampaignDAO.shared.read(id: "a")
                    var campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "foo", activeStatuses: activeStatuses)
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "bar", activeStatuses: activeStatuses)
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(1))
                }
                
                it("should display only the first campaign that trigger sorted by most recently created") {
                    let now = Date()
                    
                    let campaigns = [
                        UBMock.campaignMockWithRules(id: "a", createdAt: now.addingTimeInterval(TimeInterval(20))),
                        UBMock.campaignMockWithRules(id: "b", createdAt: now)
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }
                    storeMock.campaigns = campaigns
                    
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
                    var campaignA = UBCampaignDAO.shared.read(id: "a")
                    var campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "foo", activeStatuses: activeStatuses)
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "bar", activeStatuses: activeStatuses)
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(1))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                }
                
                it("should display only the first campaign that trigger sorted by most recently created") {
                    let now = Date()
                    
                    let campaigns = [
                        UBMock.campaignMockWithRules(id: "a", createdAt: now.addingTimeInterval(TimeInterval(20))),
                        UBMock.campaignMockWithRules(id: "b", createdAt: now.addingTimeInterval(TimeInterval(40)))
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }
                    storeMock.campaigns = campaigns
                    
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
                    var campaignA = UBCampaignDAO.shared.read(id: "a")
                    var campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "foo", activeStatuses: activeStatuses)
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "bar", activeStatuses: activeStatuses)
                    campaignA = UBCampaignDAO.shared.read(id: "a")
                    campaignB = UBCampaignDAO.shared.read(id: "b")
                    expect(campaignA?.numberOfTimesTriggered).to(equal(0))
                    expect(campaignB?.numberOfTimesTriggered).to(equal(1))
                }
                
                it("should display only the first campaign that triggered and that can be displayed") {
                    var campaignA = UBMock.campaignMockWithRules(id: "a")
                    var campaignB = UBMock.campaignMockWithRules(id: "b")
                    campaignA.numberOfTimesTriggered = 1
                    campaignA.maximumDisplays = 1
                    let campaigns = [campaignA, campaignB]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }
                    storeMock.campaigns = campaigns
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
                    campaignA = UBCampaignDAO.shared.read(id: "a")!
                    campaignB = UBCampaignDAO.shared.read(id: "b")!
                    expect(campaignA.numberOfTimesTriggered).to(equal(1))
                    expect(campaignB.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "foo", activeStatuses: activeStatuses)
                    campaignA = UBCampaignDAO.shared.read(id: "a")!
                    campaignB = UBCampaignDAO.shared.read(id: "b")!
                    expect(campaignA.numberOfTimesTriggered).to(equal(1))
                    expect(campaignB.numberOfTimesTriggered).to(equal(0))
                    campaignManager.sendEvent(event: "bar", activeStatuses: activeStatuses)
                    campaignA = UBCampaignDAO.shared.read(id: "a")!
                    campaignB = UBCampaignDAO.shared.read(id: "b")!
                    expect(campaignA.numberOfTimesTriggered).to(equal(1))
                    expect(campaignB.numberOfTimesTriggered).to(equal(1))
                }
                it("should display campaign if the semaphore allow it and the campaign can be displayed again") {
                    let leaf = LeafEvent(event: Event(name: "foo"))
                    let leaf2 = LeafEvent(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf, leaf2])

                    let campaigns = [
                        CampaignModel(id: "a", rule: rule, formId: "", targetingId: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .active, createdAt: Date())
                    ]
                    campaigns.forEach {
                        UBCampaignDAO.shared.create($0)
                    }

                    storeMock.campaigns = campaigns
                    storeMock.form = UBMock.formMock()
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "test")
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

            context("when displaying a campaign form : displayCampaignForm") {
                beforeEach {
                    CampaignWindow.shared.campaignDidEnd(success: false)
                }
                it("should display the form") {
                    let form = UBMock.formMock()
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "")
                    expect(campaignManager.displayCampaignForm(form)).to(beTrue())
                }
                it("should not display the form when campaign is already displayed") {
                    let form = UBMock.formMock()
                    let campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "")
                    expect(campaignManager.displayCampaignForm(form)).to(beTrue())
                    expect(campaignManager.displayCampaignForm(form)).to(beFalse())
                }
            }

            context("when displaying a campaign: displayCampaign") {
                var campaignManager: CampaignManager!
                var campaign: CampaignModel!
                beforeEach {
                    CampaignWindow.shared.campaignDidEnd(success: false)
                    storeMock.getCampaignFormHasBeenCalled = false
                    storeMock.form = nil
                    UsabillaFeedbackForm.canDisplayCampaigns = true
                    campaign = UBMock.campaignMockWithRules()
                    campaignServiceMock = UBCampaignServiceMock()
                    campaignManager = CampaignManager(campaignStore: storeMock, campaignService: campaignServiceMock, appId: "")
                }
                it("should not display the campaign if it cannot be displayed") {
                    UsabillaFeedbackForm.canDisplayCampaigns = false

                    expect(campaign.canBeDisplayed).to(beTrue())
                    expect(storeMock.getCampaignFormHasBeenCalled).to(beFalse())
                    campaignManager.displayCampaign(campaign)
                    expect(storeMock.getCampaignFormHasBeenCalled).to(beFalse())
                }
                it("should diplay the campaign form") {
                    storeMock.form = UBMock.formMock()
                    let formMock = UBMock.formMock()

                    expect(campaign.canBeDisplayed).to(beTrue())
                    expect(storeMock.getCampaignFormHasBeenCalled).to(beFalse())
                    campaignManager.displayCampaign(campaign)
                    expect(storeMock.getCampaignFormHasBeenCalled).to(beTrue())
                    expect(CampaignWindow.shared.showCampaign(CampaignViewModel(form: formMock, manager: manager))).to(beFalse())
                }
                it("should not diplay the campaign form when the form does not exist") {
                    let formMock = UBMock.formMock()

                    expect(campaign.canBeDisplayed).to(beTrue())
                    expect(storeMock.getCampaignFormHasBeenCalled).to(beFalse())
                    campaignManager.displayCampaign(campaign)
                    expect(storeMock.getCampaignFormHasBeenCalled).to(beTrue())
                    expect(CampaignWindow.shared.showCampaign(CampaignViewModel(form: formMock, manager: manager))).to(beTrue())
                }

                it("should increment the number of views when it is displayed") {
                    storeMock.form = UBMock.formMock()
                    campaignServiceMock.incrementCampaignSucceed = true
                    expect(campaign.canBeDisplayed).to(beTrue())

                    waitUntil(timeout: 2) { done in
                        campaignServiceMock.onIncrementCampaign = { campaignId, viewCount in
                            expect(campaignId).to(equal(campaign.identifier))
                            expect(viewCount).to(equal(1))
                            done()
                        }
                        campaignManager.displayCampaign(campaign)
                    }
                }

                it("should increment the number of views when it is not displayed") {
                    storeMock.form = UBMock.formMock()
                    campaignServiceMock.incrementCampaignSucceed = true
                    expect(campaign.canBeDisplayed).to(beTrue())
                    UsabillaFeedbackForm.canDisplayCampaigns = false
                    campaignServiceMock.onIncrementCampaign = { campaignId, viewCount in
                        fail("should not be called")
                    }
                    campaignManager.displayCampaign(campaign)
                }
            }
        }
    }
}
