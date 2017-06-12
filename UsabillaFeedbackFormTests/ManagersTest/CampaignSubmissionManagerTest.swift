//
//  CampaignSubmissionManagerTest.swift
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
        print("hello")
        lastRequest = request
        counter += 1
        return Promise { fulfill, _ in
            fulfill("feedbackId")
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

class CampaignSubmissionManagerTest: QuickSpec {

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

        describe("the Campaign Submission Manager") {

            context("With a valid feedback Id") {

                it("Sends a single page correctly") {
                    let page = UBPageModelMock()
                    page.type = .form
                    campaignSubmissionManager.submitPage(page: page, newPageType: .form)
                    let json = campaignService.requestJSON!
                    expect(json["metadata"].exists()).to(beFalse())
                    expect(json["data"]["one"]).to(equal(["one"]))
                }

                it("Sends the metadata page correctly") {
                    let page = UBPageModelMock()
                    page.type = .start
                    campaignSubmissionManager.submitPage(page: page, newPageType: .form)
                    let json = campaignService.requestJSON!
                    expect(json["data"]["one"]).to(equal(["one"]))
                    expect(json["app_id"]).to(equal("appId"))
                    expect(json["form_version"]).to(equal(0))
                    expect(json["metadata"]).toNot(beNil())
                    expect(json["metadata"]["system"]).to(equal("ios"))
                }

                it("Sends the closing page correctly") {
                    let page = UBPageModelMock()
                    page.type = .form
                    campaignSubmissionManager.submitPage(page: page, newPageType: .end)
                    let json = campaignService.requestJSON!
                    expect(json["data"]["one"]).to(equal(["one"]))
                    expect(json["metadata"].exists()).to(beFalse())
                    expect(json["complete"]).to(equal(true))
                }
            }
        }
    }
}
