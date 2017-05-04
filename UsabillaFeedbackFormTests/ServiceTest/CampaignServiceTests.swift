//
//  CampaignServiceTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaignServiceTests: QuickSpec {
    override func spec() {
        describe("CampaignService") {
            context("When getCampaignForm is called") {
                it("should succeed if request succeeds") {
                    UBHTTPMockSuccess.self.result = []
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockSuccess.self).getCampaignForm(withId: "a").then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockFail.self).getCampaignForm(withId: "a").then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }

            context("When getCampaigns is called") {
                it("should succeed if request succeeds") {
                    UBHTTPMockSuccess.self.result = [Cachable<[CampaignModel]>(value: [CampaignModel(id: "campIDTest", json: JSON(""))], hasChanged: true)]
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockSuccess.self).getCampaigns(withAppId: "appid").then { result in
                            expect(result.hasChanged).to(beFalse())
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockFail.self).getCampaigns(withAppId: "appid").then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }

            context("When getTargeting is called") {
                it("should succeed if request succeeds") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockSuccess.self).getTargeting(withId: "tid").then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockFail.self).getTargeting(withId: "tid").then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }
        }
    }
}
