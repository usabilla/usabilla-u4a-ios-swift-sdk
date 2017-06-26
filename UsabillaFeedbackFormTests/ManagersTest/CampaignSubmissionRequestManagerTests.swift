//
//  File.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 19/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaignSubmissionRequestManagerTests: QuickSpec {

    override func spec() {
        let reachabilityMock = ReachabilityMock()
        var campaignSubmissionManager: CampaignSubmissionRequestManager!
        let manager = CampaignSubmissionManagerMock()

        beforeSuite {
            campaignSubmissionManager = CampaignSubmissionRequestManager(appId: "appId", campaignId: "campaignId", formVersion: 0, customVars: nil, campaignSubmissionManager: manager, reachability: reachabilityMock)
        }

        describe("the CampaignSubmissionRequestManager") {

            it("Sends the id payload only on the first call") {
                let campman = CampaignSubmissionRequestManager(appId: "appId", campaignId: "campaignId", formVersion: 0, customVars: nil, campaignSubmissionManager: manager, reachability: reachabilityMock)
                let expectedURL = "https://api-staging.usabilla.com/v2/sdk/campaigns/campaignId/feedback"
                let page = UBPageModelMock()
                page.type = .form
                campman.savePage(page: page, nextPageType: .form)

                //This checks that the feedbackID has not been added to the URL as a parameter, should only happen on the first call
                let firstCallURL = manager.lastRequest?.request.url?.absoluteString
                expect(firstCallURL).to(equal(expectedURL))
                campman.savePage(page: page, nextPageType: .form)

                //This checks that the feedbackID has been added to the URL as a parameter, as it should be for every call after the first
                let secondCallURL = manager.lastRequest?.request.url?.absoluteString
                expect(secondCallURL!.characters.count).to(beGreaterThan(expectedURL.characters.count))
            }

            it("Sends a single page correctly") {
                let page = UBPageModelMock()
                page.type = .form
                campaignSubmissionManager.savePage(page: page, nextPageType: .form)
                let json = manager.requestJSON!
                expect(json["metadata"].exists()).to(beFalse())
                expect(json["data"]["one"]).to(equal(["one"]))
            }

            it("Sends the start or banner page correctly") {
                let page = UBPageModelMock()
                page.type = .banner
                campaignSubmissionManager.savePage(page: page, nextPageType: .form)
                let json = manager.requestJSON!
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
                campaignSubmissionManager.savePage(page: page, nextPageType: .toast)
                let json = manager.requestJSON!
                expect(json["data"]["one"]).to(equal(["one"]))
                expect(json["metadata"].exists()).to(beFalse())
                expect(json["complete"]).to(equal(true))
            }
        }
    }
}
