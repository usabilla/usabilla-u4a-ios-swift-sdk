//
//  CampaignServiceTests.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length
// swiftlint:disable force_try
import Quick
import Nimble

@testable import Usabilla

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
                it("should fail if there is no data nor error") {
                    UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: true, isChanged: true)
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMock.self).getCampaignForm(withID: "a").then { _ in
                            fail("should not go here")
                            }.catch { _ in
                                done()
                        }
                    }
                }
            }

            context("When getCampaignsJSON is called") {
                context("and everything goes well") {
                    it("should succeed if request succeeds") {
                        UBHTTPMockSuccess.self.result = []
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMockSuccess.self).getCampaignsJSON(withAppID: "appid").then { result in
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                    it("should correctly return the isChanged status") {
                        let campaignListJSON = try! JSON.init(parseJSON: "[]").rawData()
                        UBHTTPMock.response = HTTPClientResponse(data: campaignListJSON, headers: nil, error: nil, success: true, isChanged: true)
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMock.self).getCampaignsJSON(withAppID: "appId").then { cachableCampaigns in
                                expect(cachableCampaigns.value).notTo(beNil())
                                expect(cachableCampaigns.value.count).to(equal(0))
                                expect(cachableCampaigns.hasChanged).to(beTrue())
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }

                        UBHTTPMock.response = HTTPClientResponse(data: campaignListJSON, headers: nil, error: nil, success: true, isChanged: false)
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMock.self).getCampaignsJSON(withAppID: "appId").then { cachableCampaigns in
                                expect(cachableCampaigns.value).notTo(beNil())
                                expect(cachableCampaigns.value.count).to(equal(0))
                                expect(cachableCampaigns.hasChanged).to(beFalse())
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                    it("should correctly return an empty array if no campaigns are found") {
                        let campaignListJSON = try! JSON.init(parseJSON: "[]").rawData()
                        UBHTTPMock.response = HTTPClientResponse(data: campaignListJSON, headers: nil, error: nil, success: true, isChanged: true)
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMock.self).getCampaignsJSON(withAppID: "appId").then { cachableCampaigns in
                                expect(cachableCampaigns.value).notTo(beNil())
                                expect(cachableCampaigns.value.count).to(equal(0))
                                expect(cachableCampaigns.hasChanged).to(beTrue())
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                    it("should correctly parse an array of campaigns JSON") {
                        let campaignListJSON = try! UBMock.json(fromFile: "CampaignServiceTest", "campaigns").rawData()
                        UBHTTPMock.response = HTTPClientResponse(data: campaignListJSON, headers: nil, error: nil, success: true, isChanged: true)
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMock.self).getCampaignsJSON(withAppID: "appId").then { cachableCampaigns in
                                expect(cachableCampaigns.value).notTo(beNil())
                                expect(cachableCampaigns.value.count).to(equal(4))
                                expect(cachableCampaigns.hasChanged).to(beTrue())
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                }
                context("and there are errors") {
                    it("should fail if request fails") {
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMockFail.self).getCampaignsJSON(withAppID: "appid").then { _ in
                                fail("should not go here")
                            }.catch { _ in
                                done()
                            }
                        }
                    }
                    it("should fail if there is an error") {
                        UBHTTPMock.response = HTTPClientResponse(data: JSON.init(parseJSON: "{\"a\":\"a\"}"), headers: nil, error: nil, success: true, isChanged: true)
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMock.self).getCampaignsJSON(withAppID: "appid").then { _ in
                                fail("should not go here")
                                }.catch { _ in
                                    done()
                            }
                        }
                    }
                }
            }
            context("When getTargetings is called") {
                context("and everything goes well") {
                    it("should succeed if request succeeds") {
                        waitUntil(timeout: 2.0) { done in
                            UBHTTPMock.response = HTTPClientResponse(data: targetingData, headers: nil, error: nil, success: true, isChanged: true)
                            CampaignService(httpClient: UBHTTPMock.self).getTargetings(withIDs: ["tid"]).then { _ in
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                    it("should correctly parse an array of targeting") {
                        let targetingListJSON = try! UBMock.json(fromFile: "CampaignServiceTest", "targetings").rawData()
                        let targetingIDs: [String] = []
                        UBHTTPMock.response = HTTPClientResponse(data: targetingListJSON, headers: nil, error: nil, success: true, isChanged: true)
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMock.self).getTargetings(withIDs: targetingIDs).then { targetings in
                                expect(targetings).notTo(beNil())
                                expect(targetings.count).to(equal(4))
                                let targeting = targetings.first { $0.targetingID == "6ad0b9e2-d336-4c74-b72b-bc6d90dc8258" }
                                expect(targeting).notTo(beNil())
                                expect(targeting?.lastModifiedDate).notTo(beNil())
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                    it("should correctly parse an empty array of targetings") {
                        let targetingListJSON = try! JSON.init(parseJSON: "[]").rawData()
                        UBHTTPMock.response = HTTPClientResponse(data: targetingListJSON, headers: nil, error: nil, success: true, isChanged: true)
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMock.self).getTargetings(withIDs: []).then { targetings in
                                expect(targetings).notTo(beNil())
                                expect(targetings.count).to(equal(0))
                                done()
                            }.catch { _ in
                                fail("should not go here")
                            }
                        }
                    }
                }
                context("and there are errors") {
                    it("should fail if request succeeds and json is invalid") {
                        let data = try! JSON(parseJSON: "{\"hello\":\"you\"}").rawData()
                        waitUntil(timeout: 2.0) { done in
                            UBHTTPMock.response = HTTPClientResponse(data: data, headers: nil, error: nil, success: true, isChanged: true)
                            CampaignService(httpClient: UBHTTPMock.self).getTargetings(withIDs: ["tid"]).then { _ in
                                fail("should not go here")
                            }.catch { _ in
                                done()
                            }
                        }
                    }
                    it("should fail if request fails") {
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMockFail.self).getTargetings(withIDs: ["tid"]).then { _ in
                                fail("should not go here")
                            }.catch { _ in
                                done()
                            }
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

                it("should succeed and return header if post request succeeds") {
                    waitUntil(timeout: 2.0) { done in
                        UBHTTPMock.response = HTTPClientResponse(data: nil, headers: ["Location": "this_should/not/appear/location"], error: nil, success: true, isChanged: true)
                        let request = URLRequest(url: URL(string: "http://test.com")!)
                        CampaignService(httpClient: UBHTTPMock.self).submit(withRequest: request).then { succeed in
                            expect(succeed).to(equal("location"))
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }

                it("should succeed and return nil if patch request succeeds") {
                    waitUntil(timeout: 2.0) { done in
                        UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: true, isChanged: true)
                        let request = URLRequest(url: URL(string: "http://test.com")!)
                        CampaignService(httpClient: UBHTTPMock.self).submit(withRequest: request).then { succeed in
                            expect(succeed).to(beNil())
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
