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
    func submit(withRequest request: URLRequest) -> Promise<String> {
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
        var csm: CampaignSubmissionManager!
        let dao = UBCampaignFeedbackRequestDAO.shared

        let item1 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), id: "1498039389940")
        let item2 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), id: "1498039389960")
        let item5 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), id: "1498039389990")

        beforeSuite {
            csm = CampaignSubmissionManager(DAO: dao, service: SubmitServiceMock(), reachability: reachabilityMock)
        }

        describe("the CampaignSubmissionManager") {

            beforeEach {
                dao.deleteAll()
            }

            it("should work online and offline") {
                //set offline
                reachabilityMock.reachable = false

                csm.handle(request: item1)
                expect(dao.readAll().count).to(equal(1))
                csm.handle(request: item2)
                expect(dao.readAll().count).to(equal(2))
                csm.handle(request: item5)
                expect(dao.readAll().count).to(equal(3))

                //set online
                reachabilityMock.reachable = true
                expect(dao.readAll().count).toEventually(equal(0), timeout: 4)
            }

        }
    }
}
