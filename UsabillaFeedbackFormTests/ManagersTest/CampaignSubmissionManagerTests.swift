//
//  CampaignSubmissionManagerTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 12/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class SubmitServiceMock: CampaignServiceProtocol {

    var lastRequest: URLRequest?
    var requestJSON: JSON? {
        if let request = lastRequest {
            return JSON(request.httpBody as Any)
        }
        return nil
    }
    var counter = 0
    func submitCampaignResult(withRequest request: URLRequest) -> Promise<String> {
        lastRequest = request
        counter += 1
        return Promise { fulfill, _ in
            fulfill("/v2/sdk/feedback/452DEE0D-D2C2-4B87-8DA9-BCF8D946C183")
        }
    }

    var campaignsResponse: Cachable<[CampaignModel]>?
    var targetingResponse: Cachable<Rule>?
    var campaignForm: FormModel?

    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getCampaignForm(withId id: String) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            if campaignForm != nil {
                return fulfill(campaignForm!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func getCampaigns(withAppId appId: String) -> Promise<Cachable<[CampaignModel]>> {
        return Promise { fulfill, reject in
            if campaignsResponse != nil {
                return fulfill(campaignsResponse!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func getTargeting(withId id: String) -> Promise<Cachable<Rule>> {
        return Promise { fulfill, reject in
            if targetingResponse != nil {
                return fulfill(targetingResponse!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

}

class CampaignSubmissionManagerTests: QuickSpec {

    override func spec() {
        let reachabilityMock = ReachabilityMock()
        var campaignService: SubmitServiceMock!
        var campaignSubmissionManager: CampaignSubmissionManager!

        beforeSuite {
            campaignService = SubmitServiceMock()
            campaignSubmissionManager = CampaignSubmissionManager(appId: "appId", campaignId: "campaignId", formVersion: 0, customVars: nil, campaignService: campaignService, reachability: reachabilityMock)
        }

        beforeEach {
            campaignService.lastRequest = nil
        }

        describe("the CampaignSubmissionManager") {

            it("Sends the id payload only on the first call") {
                let manager = CampaignSubmissionManager(appId: "appId", campaignId: "campaignId", formVersion: 0, customVars: nil, campaignService: campaignService, reachability: reachabilityMock)
                let expectedURL = "https://api-staging.usabilla.com/v2/sdk/campaigns/campaignId/feedback/"
                let page = UBPageModelMock()
                page.type = .form
                manager.submitPage(page: page, nextPageType: .form)

                //This checks that the feedbackID has not been added to the URL as a parameter, should only happen on the first call
                let firstCallURL = campaignService.lastRequest?.url?.absoluteString
                expect(firstCallURL).to(equal(expectedURL))
                manager.submitPage(page: page, nextPageType: .form)

                //This checks that the feedbackID has been added to the URL as a parameter, as it should be for every call after the first
                let secondCallURL = campaignService.lastRequest?.url?.absoluteString
                expect(secondCallURL!.characters.count).to(beGreaterThan(expectedURL.characters.count))
            }

            it("Sends a single page correctly") {
                let page = UBPageModelMock()
                page.type = .form
                campaignSubmissionManager.submitPage(page: page, nextPageType: .form)
                let json = campaignService.requestJSON!
                expect(json["metadata"].exists()).to(beFalse())
                expect(json["data"]["one"]).to(equal(["one"]))
            }

            it("Sends the start or banner page correctly") {
                let page = UBPageModelMock()
                page.type = .start
                campaignSubmissionManager.submitPage(page: page, nextPageType: .form)
                let json = campaignService.requestJSON!
                expect(json["data"]["one"]).to(equal(["one"]))
                expect(json["app_id"]).to(equal("appId"))
                expect(json["form_version"]).to(equal(0))
                expect(json["metadata"]).toNot(beNil())
                expect(json["metadata"]["system"]).to(equal("ios"))
                expect(json["id"].exists()).to(beTrue())
            }

            it("Sends the closing page correctly") {
                let page = UBPageModelMock()
                page.type = .form
                campaignSubmissionManager.submitPage(page: page, nextPageType: .end)
                let json = campaignService.requestJSON!
                expect(json["data"]["one"]).to(equal(["one"]))
                expect(json["metadata"].exists()).to(beFalse())
                expect(json["complete"]).to(equal(true))
            }
        }
    }
}
