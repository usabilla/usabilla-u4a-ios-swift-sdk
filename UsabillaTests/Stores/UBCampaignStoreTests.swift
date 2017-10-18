//
//  UBCampaignStoreTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 14/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length

import Quick
import Nimble

@testable import Usabilla

class UBCampaignStoreTests: QuickSpec {
    var campaign1: CampaignModel!
    var campaign2: CampaignModel!

    override func spec() {
        describe("UBCampaignStoreTests") {
            var store: UBCampaignStore!

            beforeEach {
                self.campaign1 = UBMock.campaignMock(withID: "cmp1")
                self.campaign2 = UBMock.campaignMock(withID: "cmp2")
                UBCampaignDAO.shared.deleteAll()
            }

            context("When fetching campaigns") {
                it("should return the correct data when result contains No Campains") {
                    let campaignService = UBCampaignServiceMock()
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [], hasChanged: false)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
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
                    let rule: ConcreteRule = ConcreteRule(type: RuleType.and, childRules: [])
                    let targeting = TargetingOptionsModel(rule: rule, targetingID: "tid", lastModifiedDate: nil)
                    campaignService.targetingResponse = Cachable<TargetingOptionsModel>(value: targeting, hasChanged: true)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(2))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should return result rule if targeting has not changed and not found in cache") {
                    let campaignService = UBCampaignServiceMock()
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [self.campaign1], hasChanged: true)
                    let rule: ConcreteRule = ConcreteRule(type: RuleType.and, childRules: [])
                    let targeting = TargetingOptionsModel(rule: rule, targetingID: "tid", lastModifiedDate: nil)
                    campaignService.targetingResponse = Cachable<TargetingOptionsModel>(value: targeting, hasChanged: false)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(1))
                            let campaign = campaigns.first
                            let campaignModel = UBCampaignDAO.shared.read(id: (campaign?.identifier)!)
                            UBCampaignDAO.shared.delete(campaignModel!)
                            expect(campaign?.targeting?.rule).toNot(beNil())
                            expect(campaign?.targeting?.rule.childRules.count).to(equal(0))
                            expect(campaign?.targeting?.rule.type).to(equal(RuleType.and))
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
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(0))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should filter out invalid campaigns") {
                    let campaignService = UBCampaignServiceMock()
                    let cmp1 = CampaignModel(id: "cmp1", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .invalid, createdAt: Date())
                    let cmp2 = CampaignModel(id: "cmp2", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .invalid, createdAt: Date())
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [cmp1, cmp2], hasChanged: true)

                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(0))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should filter out invalid campaigns when there are in/active ones") {
                    let campaignService = UBCampaignServiceMock()
                    let cmp1 = CampaignModel(id: "cmp1", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .invalid, createdAt: Date())
                    let cmp2 = CampaignModel(id: "cmp2", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .invalid, createdAt: Date())
                    let cmp3 = CampaignModel(id: "cmp3", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .active, createdAt: Date())
                    let cmp4 = CampaignModel(id: "cmp4", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .inactive, createdAt: Date())

                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [cmp1, cmp2, cmp3, cmp4], hasChanged: true)

                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        store.getCampaigns(withAppID: "").then { campaigns in
                            expect(campaigns.count).to(equal(1))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should return an empty list of campaigns if there are no ACTIVE ones") {
                    let campaignService = UBCampaignServiceMock()
                    let cmp1 = CampaignModel(id: "cmp1", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .invalid, createdAt: Date())
                    let cmp2 = CampaignModel(id: "cmp2", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .invalid, createdAt: Date())
                    let cmp3 = CampaignModel(id: "cmp3", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .inactive, createdAt: Date())
                    let cmp4 = CampaignModel(id: "cmp4", targeting: nil, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .inactive, createdAt: Date())

                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [cmp1, cmp2, cmp3, cmp4], hasChanged: true)

                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(0))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should update inactive campaigns in cache") {
                    let campaignService = UBCampaignServiceMock()
                    let cmp1 = UBMock.campaignMockWithRules(id: "cmp1")
                    cmp1.numberOfTimesTriggered = 17
                    UBCampaignDAO.shared.create(cmp1)
                    let cmpInactive = UBMock.campaignMockWithRules(id: "cmp1")
                    cmpInactive.status = .inactive
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [cmpInactive], hasChanged: true)

                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { _ in
                            expect(UBCampaignDAO.shared.readAll().count).to(equal(1))
                            var campaign = UBCampaignDAO.shared.readAll().first!
                            expect(campaign.targeting?.rule).toNot(beNil())
                            expect(campaign.targeting?.rule.type).to(equal(RuleType.and))
                            expect(campaign.targeting?.rule.childRules.count).to(equal(2))
                            campaign = UBCampaignDAO.shared.readAll().first!
                            expect(campaign.status).to(equal(CampaignModel.Status.inactive))
                            expect(campaign.numberOfTimesTriggered).to(equal(17))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should update targeting only for active campaigns") {
                    let campaignService = UBCampaignServiceMock()
                    let cmp1 = CampaignModel(id: "cmp1", targeting: nil, formID: "", targetingID: "t1", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .invalid, createdAt: Date())
                    let cmp2 = CampaignModel(id: "cmp2", targeting: nil, formID: "", targetingID: "t2", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .invalid, createdAt: Date())
                    let cmp3 = CampaignModel(id: "cmp3", targeting: nil, formID: "", targetingID: "t3", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .active, createdAt: Date())
                    let cmp4 = CampaignModel(id: "cmp4", targeting: nil, formID: "", targetingID: "t4", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .inactive, createdAt: Date())

                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [cmp1, cmp2, cmp3, cmp4], hasChanged: true)

                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        campaignService.onGetTargeting = { id in
                            expect(id).to(equal(cmp3.targetingID))
                            done()
                        }
                        _ = store.getCampaigns(withAppID: "")
                    }
                }

                it("should keep the persisted property numberOfTimesTriggered") {
                    let campaignService = UBCampaignServiceMock()
                    let cmp1 = UBMock.campaignMockWithRules(id: "cmp1")
                    cmp1.numberOfTimesTriggered = 18
                    UBCampaignDAO.shared.create(cmp1)
                    let cmpActive = UBMock.campaignMockWithRules(id: "cmp1")
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [cmpActive], hasChanged: true)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { _ in
                            expect(UBCampaignDAO.shared.readAll().count).to(equal(1))
                            var campaign = UBCampaignDAO.shared.readAll().first!
                            campaign = UBCampaignDAO.shared.readAll().first!
                            expect(campaign.numberOfTimesTriggered).to(equal(18))
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
                    let rule: ConcreteRule = ConcreteRule(type: RuleType.and, childRules: [])
                    let targeting = TargetingOptionsModel(rule: rule, targetingID: "tid", lastModifiedDate: nil)
                    campaignService.targetingResponse = Cachable<TargetingOptionsModel>(value: targeting, hasChanged: true)
                    store = UBCampaignStore(service: campaignService)

                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
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
                    let targeting1 = TargetingOptionsModel(rule: fakeRule, targetingID: "tid", lastModifiedDate: nil)
                    self.campaign1.targeting = targeting1
                    UBCampaignDAO.shared.create(self.campaign1)
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [self.campaign1], hasChanged: true)
                    let rule: ConcreteRule = ConcreteRule(type: RuleType.and, childRules: [])
                    let targeting = TargetingOptionsModel(rule: rule, targetingID: "tid", lastModifiedDate: nil)
                    campaignService.targetingResponse = Cachable<TargetingOptionsModel>(value: targeting, hasChanged: false)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(1))
                            expect(campaigns.first?.targeting?.rule.type).to(equal(RuleType.or))
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
                    let targeting = TargetingOptionsModel(rule: fakeRule, targetingID: "tid", lastModifiedDate: nil)
                    self.campaign1.targeting = targeting
                    UBCampaignDAO.shared.create(self.campaign1)
                    campaignService.campaignsResponse = Cachable<[CampaignModel]>(value: [self.campaign1], hasChanged: true)
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(1))
                            expect(campaigns.first?.targeting?.rule.type).to(equal(RuleType.or))
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
                        let promise = store.getCampaigns(withAppID: "")
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
                        let promise = store.getCampaigns(withAppID: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(2))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            }

            context("When fetching campaign form") {
                it("should return an error when an error is sent from the campaignService") {
                    let campaignService = UBCampaignServiceMock()
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaignForm(withFormID: "test", theme: UsabillaTheme())
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should return a form") {
                    let campaignService = UBCampaignServiceMock()
                    let form = UBMock.formMock()
                    campaignService.campaignForm = form
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaignForm(withFormID: "test", theme: UsabillaTheme())
                        promise.then { formResponse in
                            expect(formResponse).to(equal(form))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should update the theme when returning a form") {
                    let campaignService = UBCampaignServiceMock()
                    let form = UBMock.formMock()
                    campaignService.campaignForm = form
                    store = UBCampaignStore(service: campaignService)
                    var theme = UsabillaTheme()
                    theme.colors.header = UIColor.purple
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaignForm(withFormID: "test", theme: theme)
                        promise.then { formResponse in
                            expect(formResponse.theme.colors.header).to(equal(UIColor.purple))
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
