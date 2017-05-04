//
//  UBCampaignStoreTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 14/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBCampaignStoreTests: QuickSpec {
    var campaign1: CampaignModel!
    var campaign2: CampaignModel!

    override func spec() {
        describe("UBCampaignStoreTests") {
            var store: UBCampaignStore!

            beforeEach {
                self.campaign1 = CampaignModel(id: "cmp1", json: JSON(""))
                self.campaign2 = CampaignModel(id: "cmp2", json: JSON(""))
                UBCampaignDAO.shared.deleteAll()
            }

            context("When fetching campaigns") {
                it("should return the correct data when result contains No Campains") {
                    let campaignService = UBCampaignServiceMock()
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [], hasChanged: false)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(0))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should return the correct data when result contains a list of Campains") {
                    let campaignService = UBCampaignServiceMock()
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [self.campaign1, self.campaign2], hasChanged: true)
                    campaignService.targetingResponse = Cachable<Rule>(value: ConcreteRule(type: RuleType.and, childRules: []), hasChanged: true)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(2))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should return the correct data when result has changed") {
                    let campaignService = UBCampaignServiceMock()
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [], hasChanged: true)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(0))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            }

            context("When fetching campaigns with existing local cache") {
                it("should delete non existing ones anymore and update cache") {
                    UBCampaignDAO.shared.create(self.campaign1)
                    UBCampaignDAO.shared.create(self.campaign2)
                    // fetch new campaigns from network
                    let campaignService = UBCampaignServiceMock()
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [self.campaign1], hasChanged: true)
                    campaignService.targetingResponse = Cachable<Rule>(value: ConcreteRule(type: RuleType.and, childRules: []), hasChanged: true)
                    store = UBCampaignStore(service: campaignService)

                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(1))
                            expect(campaigns.first!.identifier).to(equal(self.campaign1.identifier))
                            let allCampaigns = UBCampaignDAO.shared.readAll()
                            expect(allCampaigns.count).to(equal(1))
                            expect(allCampaigns.first?.identifier).to(equal(self.campaign1.identifier))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            }

            context("When fetching campaigns with unchanged targeting") {
                it("should return cahced targeting") {
                    let campaignService = UBCampaignServiceMock()
                    let fakeRule = ConcreteRule(type: RuleType.or, childRules: [])
                    self.campaign1.rule = fakeRule
                    UBCampaignDAO.shared.create(self.campaign1)
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [self.campaign1], hasChanged: true)
                    campaignService.targetingResponse = Cachable<Rule>(value: ConcreteRule(type: RuleType.and, childRules: []), hasChanged: false)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(1))
                            expect(campaigns.first?.rule?.type).to(equal(RuleType.or))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            }

            context("When fetching campaigns with targeting error") {
                it("should return the cached targeting") {
                    let campaignService = UBCampaignServiceMock()
                    let fakeRule = ConcreteRule(type: RuleType.or, childRules: [])
                    self.campaign1.rule = fakeRule
                    UBCampaignDAO.shared.create(self.campaign1)
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [self.campaign1], hasChanged: true)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(1))
                            expect(campaigns.first?.rule?.type).to(equal(RuleType.or))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            }

            context("When fetching campaigns with error") {
                it("should return an error") {
                    let campaignService = UBCampaignServiceMock()
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppId: "")
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should return with an array of cached campaigns") {
                    let campaignService = UBCampaignServiceMock()
                    store = UBCampaignStore(service: campaignService)
                    // add campaigns to cache
                    UBCampaignDAO.shared.create(self.campaign1)
                    UBCampaignDAO.shared.create(self.campaign2)

                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(2))
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
