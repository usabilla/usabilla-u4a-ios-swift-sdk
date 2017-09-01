//
//  CampaignServiceTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length
// swiftlint:disable force_try
import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaignServiceTests: QuickSpec {
    override func spec() {
        var targetingData: Data!
        beforeEach {
            targetingData = try! UBMock.json("CampaignTargeting")?.rawData()
        }
        describe("CampaignService") {

            context("When getCampaignForm is called") {
                it("should succeed if request succeeds") {
                    UBHTTPMockSuccess.self.result = []
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockSuccess.self).getCampaignForm(withID: "a").then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockFail.self).getCampaignForm(withID: "a").then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }

            context("When getCampaigns is called") {
                it("should succeed if request succeeds") {
                    UBHTTPMockSuccess.self.result = [Cachable<[CampaignModel]>(value: [UBMock.campaignMock(withID: "campIDTest")], hasChanged: true)]
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockSuccess.self).getCampaigns(withAppID: "appid").then { result in
                            expect(result.hasChanged).to(beFalse())
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockFail.self).getCampaigns(withAppID: "appid").then { _ in
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
                        UBHTTPMock.response = HTTPClientResponse(data: targetingData, headers: nil, error: nil, success: true, isChanged: true)
                        CampaignService(httpClient: UBHTTPMock.self).getTargeting(withID: "tid").then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request succeeds and json is invalid") {
                    let data = try! JSON.parse("{\"hello\":\"you\"}").rawData()
                    waitUntil(timeout: 2.0) { done in
                        UBHTTPMock.response = HTTPClientResponse(data: data, headers: nil, error: nil, success: true, isChanged: true)
                        CampaignService(httpClient: UBHTTPMock.self).getTargeting(withID: "tid").then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockFail.self).getTargeting(withID: "tid").then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }

            context("When incrementCampaignViews is called") {
                it("should succeed if request succeeds") {
                    waitUntil(timeout: 2.0) { done in
                        UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: true, isChanged: true)
                        CampaignService(httpClient: UBHTTPMock.self).incrementCampaignViews(forCampaignID: "1234", viewCount: 1).then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: false, isChanged: true)
                        CampaignService(httpClient: UBHTTPMock.self).incrementCampaignViews(forCampaignID: "1234", viewCount: 1).then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }

            context("When submiting campaign result") {
                it("should succeed if request succeeds") {
                    waitUntil(timeout: 2.0) { done in
                        UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: true, isChanged: true)
                        let request = URLRequest(url: URL(string: "http://test.com")!)
                        CampaignService(httpClient: UBHTTPMock.self).submit(withRequest: request).then { succeed in
                            expect(succeed).to(beTrue())
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: false, isChanged: true)
                        let request = URLRequest(url: URL(string: "http://test.com")!)
                        CampaignService(httpClient: UBHTTPMock.self).submit(withRequest: request).then { succeed in
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
