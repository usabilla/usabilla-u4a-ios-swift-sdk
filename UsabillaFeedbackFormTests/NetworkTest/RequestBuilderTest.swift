//
//  RequestBuilderTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble
@testable import UsabillaFeedbackForm

class RequestBuilderTest: QuickSpec {

    var correctUrl: URL!
    var correctUrlWithParameter: URL!
    var correctGet: URLRequest!
    var correctPost: URLRequest!
    var correctPatch: URLRequest!
    var headers: [String: String]!

    override func spec() {

        beforeSuite {
            self.headers = [
                "app-version": Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "",
                "app-name": Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? "",
                "sdk-version": Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
                "os": "iOS"
            ]
            self.correctUrl = URL(string: "https://api-staging.usabilla.com/v2/sdk/forms/")
            self.correctUrlWithParameter = URL(string: "https://api-staging.usabilla.com/v2/sdk/forms/123")
            let get = NSMutableURLRequest(url: self.correctUrlWithParameter)
            get.cachePolicy = .useProtocolCachePolicy
            get.httpMethod = "GET"
            get.allHTTPHeaderFields = self.headers
            self.correctGet = get as URLRequest

            let post = NSMutableURLRequest(url: self.correctUrlWithParameter)
            post.cachePolicy = .useProtocolCachePolicy
            post.httpMethod = "POST"
            post.allHTTPHeaderFields = self.headers
            post.allHTTPHeaderFields?["Content-Type"] = "application/json"

            self.correctPost = post as URLRequest

            let patch = NSMutableURLRequest(url: self.correctUrlWithParameter)
            post.cachePolicy = .useProtocolCachePolicy
            post.httpMethod = "PATCH"
            post.allHTTPHeaderFields = self.headers
            post.allHTTPHeaderFields?["Content-Type"] = "application/json"

            self.correctPatch = patch as URLRequest

        }

        describe("The Request builder") {
            it("Builds the campaign form request correctly") {
                let get = RequestBuilder.requestGetCampaignForm(withId: "a")
                expect(get.url?.absoluteString).to(equal("https://api-staging.usabilla.com/v2/sdk/forms/a"))
                expect(get.cachePolicy).to(equal(self.correctGet.cachePolicy))
                expect(get.httpMethod).to(equal(self.correctGet.httpMethod))
                expect(get.allHTTPHeaderFields).to(equal(self.correctGet.allHTTPHeaderFields))
            }

            it("Builds the campaign feedback item creation request correctly") {
                let req = RequestBuilder.requestCampaignFeedbackItemCreation(forCampaignId: "campaignID", withPayload: ["p": "p"])
                expect(req.url?.absoluteString).to(equal("https://api-staging.usabilla.com/v2/sdk/campaigns/campaignID/feedback"))
                expect(req.cachePolicy).to(equal(self.correctPost.cachePolicy))
                expect(req.httpMethod).to(equal(self.correctPost.httpMethod))
                expect(req.allHTTPHeaderFields).to(equal(self.correctPost.allHTTPHeaderFields))
            }

            it("Builds the campaign feedback item patch request correctly") {
                let req = RequestBuilder.requestCampaignFeedbackItemPatch(forCampaignId: "c", withPayload: ["p": "p"], withSessionToken: "t")
                expect(req.url?.absoluteString).to(equal("https://api-staging.usabilla.com/v2/sdk/campaigns/c/feedback/t"))
                expect(req.cachePolicy).to(equal(self.correctPatch.cachePolicy))
                expect(req.httpMethod).to(equal("PATCH"))
                expect(req.allHTTPHeaderFields).to(equal(self.correctPost.allHTTPHeaderFields))
            }

            it("Builds the campaign list request correctly") {
                let req = RequestBuilder.requestGetCampaigns(withAppId: "myAppId")
                expect(req.url?.absoluteString).to(equal("https://api-staging.usabilla.com/v2/sdk/campaigns?app_id=myAppId"))
                expect(req.cachePolicy).to(equal(self.correctPatch.cachePolicy))
                expect(req.httpMethod).to(equal("GET"))
            }

            it("Builds the increment campaign view request correctly") {
                let req = RequestBuilder.requestPatchCampaignViews(forCampaignId: "1234", viewCount: 2)
                expect(req.url?.absoluteString).to(equal("https://api-staging.usabilla.com/v2/sdk/campaigns/1234/views"))
                expect(req.cachePolicy).to(equal(self.correctPatch.cachePolicy))
                expect(req.httpMethod).to(equal("PATCH"))
            }
        }
    }
}
