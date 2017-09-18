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
    var campaignsResponse: Cachable<[CampaignModel]>?
    var targetingResponse: Cachable<Rule>?
    var campaignForm: FormModel?

    var submissionSucceed: Bool = true
    var returnFeedbackID: Bool = false
    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getCampaignForm(withID id: String) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            if campaignForm != nil {
                return fulfill(campaignForm!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func getCampaigns(withAppID appID: String) -> Promise<Cachable<[CampaignModel]>> {
        return Promise { fulfill, reject in
            if campaignsResponse != nil {
                return fulfill(campaignsResponse!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func getTargeting(withID id: String) -> Promise<Cachable<Rule>> {
        return Promise { fulfill, reject in
            if targetingResponse != nil {
                return fulfill(targetingResponse!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func submit(withRequest request: URLRequest) -> Promise<String?> {
        lastRequest = request
        counter += 1
        return Promise { fulfill, reject in

            if self.submissionSucceed {
                returnFeedbackID ? fulfill("newID") : fulfill(nil)
                return
            }
            reject(NSError(domain: "", code: 0, userInfo: nil))
        }
    }
    func incrementCampaignViews(forCampaignID campaignID: String, viewCount: Int) -> Promise<Bool> {
        return Promise { fulfill, reject in
            fulfill(true)
        }
    }
}

class CampaignSubmissionManagerTests: QuickSpec {

    override func spec() {

        var reachabilityMock: ReachabilityMock!
        var csm: CampaignSubmissionManager!
        let dao = UBCampaignFeedbackRequestDAO.shared
        var submissionService: SubmitServiceMock!

        let post = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), internalID: "internalID", id: "1498039389940")
        let patch1 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl/internalID")!), internalID: "internalID", id: "1498039389960")
        let patch2 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl/internalID")!), internalID: "internalID", id: "1498039389990")

        describe("CampaignSubmissionManager") {

            beforeEach {
                reachabilityMock = ReachabilityMock()
                dao.deleteAll()
                submissionService = SubmitServiceMock()
                submissionService.returnFeedbackID = false
                csm = CampaignSubmissionManager(DAO: dao, dictionaryStore: UBFeedbackIDDictionaryDAO.shared, service: submissionService, reachability: reachabilityMock)
            }

            it("should work online and offline") {
                //set offline
                reachabilityMock.reachable = false

                csm.handle(request: post)
                expect(dao.readAll().count).to(equal(1))
                csm.handle(request: patch1)
                expect(dao.readAll().count).to(equal(2))
                csm.handle(request: patch2)
                expect(dao.readAll().count).to(equal(3))

                //set online
                reachabilityMock.reachable = true
                expect(dao.readAll().count).toEventually(equal(0), timeout: 4)
            }

            context("when updating a feedback item URL") {
                it("should apply the new ID to all patches") {
                    submissionService.submissionSucceed = true
                    reachabilityMock.reachable = true
                    submissionService.returnFeedbackID = true
                    csm.handle(request: post)
                    csm.handle(request: patch1)
                    expect(submissionService.lastRequest?.url?.absoluteString).toEventually(equal("https://www.google.nl/newID"), timeout: 4)
                    csm.handle(request: patch2)
                    expect(submissionService.lastRequest?.url?.absoluteString).toEventually(equal("https://www.google.nl/newID"), timeout: 4)
                }
            }

            context("when sending a request fails") {
                it("should delete the request after 3 failed attempts") {
                    reachabilityMock.reachable = true
                    expect(dao.readAll().count).to(equal(0))
                    submissionService.submissionSucceed = false
                    csm.handle(request: post)
                    expect(dao.readAll().count).toEventually(equal(1), timeout: 4)
                    var campaign = dao.readAll().first!
                    expect(campaign.numberOfSubmissionAttempts).toEventually(equal(1))
                    reachabilityMock.reachable = false
                    reachabilityMock.reachable = true
                    expect(dao.readAll().count).toEventually(equal(1), timeout: 4)
                    campaign = dao.readAll().first!
                    expect(campaign.numberOfSubmissionAttempts).toEventually(equal(2))
                    reachabilityMock.reachable = false
                    reachabilityMock.reachable = true
                    expect(dao.readAll().count).toEventually(equal(0))
                }

                it("should increase the number of attempts of this request") {
                    reachabilityMock.reachable = true
                    expect(dao.readAll().count).to(equal(0))
                    submissionService.submissionSucceed = false
                    csm.handle(request: post)
                    expect(dao.readAll().count).toEventually(equal(1))
                    let campaign = dao.readAll().first!
                    expect(campaign.numberOfSubmissionAttempts).toEventually(equal(1))
                }
            }
        }
    }
}
