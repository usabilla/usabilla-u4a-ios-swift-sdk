//
//  CampaignServiceTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaignServiceTest: QuickSpec {
    override func spec() {
        describe("CampaignService") {
            context("When getCampaignForm is called") {
                it("should succeed if request succeeds") {
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
            
            context("When getCampaignsFor is called") {

                it("should succeed if request succeeds") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockSuccess.self).getCampaignsFor(appId: "appid").then { _ in
                            done()
                            }.catch { _ in
                                fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockFail.self).getCampaignsFor(appId: "appid").then { _ in
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
