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
    var specialCampaign: CampaignModel!

    let earlierDate = Date()
    let laterDate = Date().addingTimeInterval(10000)

    override func spec() {
        let campaignJSON: JSON = UBMock.json(fromFile: "CampaignServiceTest", "campaigns")
        let targetingJSON: JSON = UBMock.json(fromFile: "CampaignServiceTest", "targetings")
        let targetingArray = targetingJSON.arrayValue.flatMap { TargetingOptionsModel(json: $0) }

        let specialTargeting = TargetingOptionsModel(json: UBMock.json(fromFile: "CampaignStoreTest", "targeting"))!
        specialCampaign = CampaignModel(id: "63f11920-4854-48df-83cc-e75d49449289", targeting: specialTargeting, formID: "9e2f845c-24db-4638-a642-365b77b31cc5", targetingID: "d314a564-e046-4ff2-a688-b8e6e32af1b3", maximumDisplays: 1, numberOfTimesTriggered: 0, status: .active, createdAt: Date())

        describe("UBCampaignStoreTests") {
            var store: UBCampaignStore!

            beforeEach {
                self.specialCampaign = CampaignModel(id: "63f11920-4854-48df-83cc-e75d49449289", targeting: specialTargeting, formID: "9e2f845c-24db-4638-a642-365b77b31cc5", targetingID: "d314a564-e046-4ff2-a688-b8e6e32af1b3", maximumDisplays: 1, numberOfTimesTriggered: 0, status: .active, createdAt: Date())
                self.campaign1 = UBMock.campaignMock(withID: "cmp1", withTargetingID: "targetingId1")
                self.campaign2 = UBMock.campaignMock(withID: "cmp2", withTargetingID: "targetingId2")
                UBCampaignDAO.shared.deleteAll()
            }

            context("When fetching campaigns") {
                context("with updated data") {
                    it("should correctly pair campaign and targeting models when data is valid") {
                        let campaignService = UBCampaignServiceMock()
                        campaignService.campaignsJSONResponse = Cachable(value: campaignJSON.arrayValue, hasChanged: true)
                        campaignService.targetingResponse = targetingArray
                        let store = UBCampaignStore(service: campaignService)
                        waitUntil(timeout: 2.0) { done in
                            store.getCampaigns(withAppID: "appId").then { campaigns in
                                expect(campaigns).notTo(beNil())
                                expect(campaigns.count).to(equal(4))
                                for model in campaigns {
                                    expect(model.targetingID).to(equal(model.targeting.targetingID))
                                }
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                    it("should correctly pair campaign and targeting models with missing targeting models") {
                        let targetingJSON: JSON = UBMock.json(fromFile: "CampaignServiceTestBroken", "targetings")
                        let targetingArray = targetingJSON.arrayValue.flatMap { TargetingOptionsModel(json: $0) }
                        let campaignService = UBCampaignServiceMock()
                        campaignService.campaignsJSONResponse = Cachable(value: campaignJSON.arrayValue, hasChanged: true)
                        campaignService.targetingResponse = targetingArray
                        let store = UBCampaignStore(service: campaignService)
                        waitUntil(timeout: 2.0) { done in
                            store.getCampaigns(withAppID: "appId").then { campaigns in
                                expect(campaigns).notTo(beNil())
                                expect(campaigns.count).to(equal(3))
                                for model in campaigns {
                                    expect(model.targetingID).to(equal(model.targeting.targetingID))
                                }
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                    it("should return an empty array if either campaigns are empty") {
                        let campaignService = UBCampaignServiceMock()
                        campaignService.campaignsJSONResponse = Cachable(value: [], hasChanged: true)
                        campaignService.targetingResponse = []
                        let store = UBCampaignStore(service: campaignService)
                        waitUntil(timeout: 2.0) { done in
                            store.getCampaigns(withAppID: "appId").then { campaigns in
                                expect(campaigns).notTo(beNil())
                                expect(campaigns.count).to(equal(0))
                                for model in campaigns {
                                    expect(model.targetingID).to(equal(model.targeting.targetingID))
                                }
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                    it("should return an empty array if targetings are empty") {
                        let campaignService = UBCampaignServiceMock()
                        campaignService.campaignsJSONResponse = Cachable(value: campaignJSON.arrayValue, hasChanged: true)
                        campaignService.targetingResponse = []
                        let store = UBCampaignStore(service: campaignService)
                        waitUntil(timeout: 2.0) { done in
                            store.getCampaigns(withAppID: "appId").then { campaigns in
                                expect(campaigns).notTo(beNil())
                                expect(campaigns.count).to(equal(0))
                                for model in campaigns {
                                    expect(model.targetingID).to(equal(model.targeting.targetingID))
                                }
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                }
                context("with no new data") {
                    it("should return the local data without calling the service for targeting ") {
                        let campaignService = UBCampaignServiceMock()
                        campaignService.campaignsJSONResponse = Cachable(value: [], hasChanged: false)
                        campaignService.targetingResponse = nil
                        UBCampaignDAO.shared.create(self.campaign1)
                        let store = UBCampaignStore(service: campaignService)
                        waitUntil(timeout: 2.0) { done in
                            store.getCampaigns(withAppID: "appId").then { campaigns in
                                expect(campaigns).notTo(beNil())
                                expect(campaigns.count).to(equal(1))
                                let campaign = campaigns.first!
                                expect(campaign.identifier).to(equal(self.campaign1.identifier))
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                }
            }
            context("When processing data") {
                it("should filter out invalid campaigns") {
                    let campaignService = UBCampaignServiceMock()
                    campaignService.campaignsJSONResponse = Cachable(value: [UBMock.json(fromFile: "CampaignServiceTestBroken", "invalidCampaign")], hasChanged: true)
                    let targetingJSON: JSON = UBMock.json(fromFile: "CampaignServiceTestBroken", "targetings")
                    let targetingArray = targetingJSON.arrayValue.flatMap { TargetingOptionsModel(json: $0) }
                    campaignService.targetingResponse = targetingArray
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        store.getCampaigns(withAppID: "").then { campaigns in
                            expect(campaigns.count).to(equal(0))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should update inactive campaigns in cache") {
                    let campaignService = UBCampaignServiceMock()
                    self.specialCampaign.status = .inactive
                    UBCampaignDAO.shared.create(self.specialCampaign)

                    campaignService.campaignsJSONResponse = Cachable(value: [UBMock.json(fromFile: "CampaignStoreTest", "campaign")], hasChanged: true)
                    campaignService.targetingResponse = [specialTargeting]

                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        store.getCampaigns(withAppID: "").then { _ in
                            expect(UBCampaignDAO.shared.readAll().count).to(equal(1))
                            let campaign = UBCampaignDAO.shared.readAll().first!
                            expect(campaign.status).to(equal(CampaignModel.Status.active))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }

                it("should keep the persisted property numberOfTimesTriggered") {
                    let campaignService = UBCampaignServiceMock()
                    self.specialCampaign.numberOfTimesTriggered = 10
                    UBCampaignDAO.shared.create(self.specialCampaign)

                    campaignService.campaignsJSONResponse = Cachable(value: [UBMock.json(fromFile: "CampaignStoreTest", "campaign")], hasChanged: true)
                    campaignService.targetingResponse = [specialTargeting]

                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        store.getCampaigns(withAppID: "").then { _ in
                            expect(UBCampaignDAO.shared.readAll().count).to(equal(1))
                            let campaign = UBCampaignDAO.shared.readAll().first!
                            expect(campaign.numberOfTimesTriggered).to(equal(10))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            }
            context("When fetching campaigns with existing local cache") {
                it("should delete non existing ones anymore and update cache") {
                    UBCampaignDAO.shared.create(self.specialCampaign)
                    let campaignService = UBCampaignServiceMock()
                    campaignService.campaignsJSONResponse = Cachable(value: [], hasChanged: true)
                    campaignService.targetingResponse = []
                    store = UBCampaignStore(service: campaignService)
                    expect(UBCampaignDAO.shared.readAll().count).to(equal(1))

                    waitUntil(timeout: 2.0) { done in
                        store.getCampaigns(withAppID: "").then { campaigns in
                            expect(campaigns.count).to(equal(0))
                            expect(UBCampaignDAO.shared.readAll().count).to(equal(0))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            }
            context("When fetching campaigns with changed targeting") {
                context("And the local storage has no last modified date") {
                    it("should correctly update the targeting") {
                        let campaignService = UBCampaignServiceMock()
                        let targeting = TargetingOptionsModel(json: UBMock.json(fromFile: "CampaignStoreTest", "datelesstargeting"))!
                        let campaign = CampaignModel(id: "63f11920-4854-48df-83cc-e75d49449289", targeting: targeting, formID: "9e2f845c-24db-4638-a642-365b77b31cc5", targetingID: "d314a564-e046-4ff2-a688-b8e6e32af1b3", maximumDisplays: 1, numberOfTimesTriggered: 0, status: .active, createdAt: Date())
                        UBCampaignDAO.shared.create(campaign)

                        campaignService.campaignsJSONResponse = Cachable(value: [UBMock.json(fromFile: "CampaignStoreTest", "campaign")], hasChanged: true)
                        campaignService.targetingResponse = [specialTargeting]

                        store = UBCampaignStore(service: campaignService)
                        waitUntil(timeout: 2.0) { done in
                            store.getCampaigns(withAppID: "").then { campaigns in
                                expect(campaigns.count).to(equal(1))
                                let storeCampaign = UBCampaignDAO.shared.read(id: "63f11920-4854-48df-83cc-e75d49449289")
                                expect(storeCampaign).toNot(beNil())
                                expect(storeCampaign?.targeting.lastModifiedDate).to(equal(specialTargeting.lastModifiedDate))
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                }
                context("And the local storage has a last modified date") {
                    it("should correctly update the targeting if the server is more recent") {
                        let campaignService = UBCampaignServiceMock()
                        let targeting = TargetingOptionsModel(json: UBMock.json(fromFile: "CampaignStoreTest", "earliertargeting"))!
                        let campaign = CampaignModel(id: "63f11920-4854-48df-83cc-e75d49449289", targeting: targeting, formID: "9e2f845c-24db-4638-a642-365b77b31cc5", targetingID: "d314a564-e046-4ff2-a688-b8e6e32af1b3", maximumDisplays: 1, numberOfTimesTriggered: 0, status: .active, createdAt: Date())
                        UBCampaignDAO.shared.create(campaign)

                        campaignService.campaignsJSONResponse = Cachable(value: [UBMock.json(fromFile: "CampaignStoreTest", "campaign")], hasChanged: true)
                        campaignService.targetingResponse = [specialTargeting]

                        store = UBCampaignStore(service: campaignService)
                        waitUntil(timeout: 2.0) { done in
                            let promise = store.getCampaigns(withAppID: "")
                            promise.then { campaigns in
                                expect(campaigns.count).to(equal(1))
                                let storeCampaign = UBCampaignDAO.shared.read(id: "63f11920-4854-48df-83cc-e75d49449289")
                                expect(storeCampaign).toNot(beNil())
                                expect(storeCampaign?.targeting.lastModifiedDate).to(equal(specialTargeting.lastModifiedDate))
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                    it("should not update the targeting if the server is equal") {
                        let campaignService = UBCampaignServiceMock()

                        UBCampaignDAO.shared.create(self.specialCampaign)
                        campaignService.campaignsJSONResponse = Cachable(value: [UBMock.json(fromFile: "CampaignStoreTest", "campaign")], hasChanged: true)
                        campaignService.targetingResponse = [specialTargeting]

                        store = UBCampaignStore(service: campaignService)
                        waitUntil(timeout: 2.0) { done in
                            let promise = store.getCampaigns(withAppID: "")
                            promise.then { campaigns in
                                expect(campaigns.count).to(equal(1))
                                let storeCampaign = UBCampaignDAO.shared.read(id: "63f11920-4854-48df-83cc-e75d49449289")
                                expect(storeCampaign).toNot(beNil())
                                expect(storeCampaign?.targeting.lastModifiedDate).to(equal(specialTargeting.lastModifiedDate))
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
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
                it("should return an error if the targetings had an error") {
                    let campaignService = UBCampaignServiceMock()
                    campaignService.campaignsJSONResponse = Cachable(value: [UBMock.json(fromFile: "CampaignStoreTest", "campaign")], hasChanged: true)
                    campaignService.targetingResponse = nil
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        store.getCampaigns(withAppID: "").then { campaigns in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }

            context("When fetching campaign form") {
                it("should return an error when an error is sent from the campaignService") {
                    let campaignService = UBCampaignServiceMock()
                    store = UBCampaignStore(service: campaignService)
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaignForm(withFormID: "test", theme: UsabillaTheme(), position: IntroPageDisplayMode.bannerBottom)
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
                        let promise = store.getCampaignForm(withFormID: "test", theme: UsabillaTheme(), position: IntroPageDisplayMode.bannerBottom)
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
                        let promise = store.getCampaignForm(withFormID: "test", theme: theme, position: IntroPageDisplayMode.bannerBottom)
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
