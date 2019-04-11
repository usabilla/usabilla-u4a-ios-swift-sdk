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

        describe("CampaignService") {

            context("When getCampaignForm is called") {
                it("should succeed if request succeeds") {
                    let validFormData = try! UBMock.json("FormWithStructure")?.rawData()
                    UBHTTPMock.response = HTTPClientResponse(data: validFormData, headers: nil, error: nil, success: true, isChanged: true)
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMock.self).getCampaignForm(withID: "a", maskModel:  nil).then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMockFail.self).getCampaignForm(withID: "a", maskModel:  nil).then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail if there is no data nor error") {
                    UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: true, isChanged: true)
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMock.self).getCampaignForm(withID: "a", maskModel:  nil).then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail if url parameter is not valid = {") {
                    UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: true, isChanged: true)
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMock.self).getCampaignForm(withID: "a{NotValidId", maskModel:  nil).then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail if url parameter is not valid = }") {
                    UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: true, isChanged: true)
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMock.self).getCampaignForm(withID: "aNotVa}lidId", maskModel:  nil).then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail when form is not instaciated correctly") {
                    let invalidFormData = try! UBMock.json("InvalidFormJsonNoPages")?.rawData()
                    UBHTTPMock.response = HTTPClientResponse(data: invalidFormData, headers: nil, error: nil, success: true, isChanged: true)
                    waitUntil(timeout: 2.0) { done in
                        CampaignService(httpClient: UBHTTPMock.self).getCampaignForm(withID: "a", maskModel:  nil).then { _ in
                            fail("should not go here")
                            }.catch { _ in
                                done()
                        }
                    }
                }
            }

            context("When getCampaignsJSON is called") {
                context("and everything goes well") {
                    it("should fail if appId is not valid") {
                        UBHTTPMockSuccess.self.result = []
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMockSuccess.self).getCampaignsJSON(withAppID: "notVal{idId").then { result in
                                fail("should not go here")
                            }.catch { _ in
                                done()
                            }
                        }
                    }
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
                            let targetingData = try! UBMock.json("CampaignTargeting")?.rawData()
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
                    it("should not fail if a targeting option is incorrect") {
                        let targetingListJSON = try! UBMock.json(fromFile: "CampaignServiceTest", "targetingsBroken").rawData()
                        let targetingIDs: [String] = []
                        UBHTTPMock.response = HTTPClientResponse(data: targetingListJSON, headers: nil, error: nil, success: true, isChanged: true)
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMock.self).getTargetings(withIDs: targetingIDs).then { targetings in
                                expect(targetings).notTo(beNil())
                                expect(targetings.count).to(equal(2))

                                let targeting1 = targetings.first
                                let targeting2 = targetings.last
                                expect(targeting1).notTo(beNil())
                                expect(targeting1?.targetingID).to(equal("6ad0b9e2-d336-4c74-b72b-bc6d90dc8258"))
                                expect(targeting1?.lastModifiedDate).notTo(beNil())
                                expect(targeting2).notTo(beNil())
                                expect(targeting2?.targetingID).to(equal("b1ddd75c-0254-44df-b5a6-2b3d806fc140"))
                                expect(targeting2?.lastModifiedDate).to(beNil())

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
                    it("should fail parameter is not valid") {
                        waitUntil(timeout: 2.0) { done in
                            CampaignService(httpClient: UBHTTPMockFail.self).getTargetings(withIDs: ["tid\\NotValid"]).then { _ in
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
                it("should succeed if request succeeds") {
                    waitUntil(timeout: 2.0) { done in
                        UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: true, isChanged: true)
                        CampaignService(httpClient: UBHTTPMock.self).incrementCampaignViews(forCampaignID: "12}34", viewCount: 1).then { _ in
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
