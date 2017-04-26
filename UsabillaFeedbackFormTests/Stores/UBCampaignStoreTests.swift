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
            var store: UBCampaignStore!
            var fakeSucceedCampaignService: CampaignService!
            var fakeFailCampaignService: CampaignService!

            beforeSuite {
                UBHTTPMockSuccess.self.result = []
                fakeSucceedCampaignService = CampaignService(httpClient: UBHTTPMockSuccess.self)
                fakeFailCampaignService = CampaignService(httpClient: UBHTTPMockFail.self)
            }

            context("When fetching campaigns") {

                beforeEach {
                    store = UBCampaignStore(service: fakeSucceedCampaignService)
                }

                it("should return the correct data") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(appId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(0))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }

                it("should return the correct data when result contains one Campain") {
                    UBHTTPMockSuccess.self.result = [CampaignModel(id: "", json: JSON(""))]
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(appId: "")
                        promise.then { campaigns in
                            expect(campaigns.count).to(equal(1))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
            }

            context("When fetching campaigns with error") {
                beforeEach {
                    store = UBCampaignStore(service: fakeFailCampaignService)
                }
                it("should return an error") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getCampaigns(appId: "")
                        promise.then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }

            context("When fetching triggers") {
                beforeEach {
                    store = UBCampaignStore(service: fakeSucceedCampaignService)
                }

                it("should ") {
                    waitUntil(timeout: 2.0) { done in
                        let promise = store.getTargetingForCampaign(id: "")
                        promise.then { _ in
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
