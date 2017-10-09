//
//  RequestBuilderTest.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble
@testable import Usabilla

class RequestBuilderTest: QuickSpec {

    var correctUrl: URL!
    var correctUrlWithParameter: URL!
    var correctGet: URLRequest!
    var correctPost: URLRequest!
    var correctPatch: URLRequest!
    var headers: [String: String]!
    var correctCDNUrl: URL!
    var correctCDNUrlWithParameter: URL!
    var correctCDNGet: URLRequest!


    override func spec() {

        beforeSuite {
            self.headers = [
                "app-version": Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "",
                "app-name": Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? "",
                "sdk-version": Bundle(identifier: "com.usabilla.Usabilla")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
                "os": "iOS",
                "sdk-build": Bundle(identifier: "com.usabilla.Usabilla")!.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "",
                "app-id": "",
                "device-model": UIDevice.current.modelName,
                "os-version": UIDevice.current.systemVersion,
                "app-bundle": Bundle.main.bundleIdentifier ?? ""
            ]
            self.correctUrl = URL(string: "https://api-staging.usabilla.com/v2/sdk/forms/")
            self.correctCDNUrl = URL(string: "https://sdk.out-staging.usbla.net/forms/")
            self.correctUrlWithParameter = URL(string: "https://api-staging.usabilla.com/v2/sdk/forms/123")
            self.correctCDNUrlWithParameter = URL(string: "https://sdk.out-staging.usbla.net/forms/123")

            let get = NSMutableURLRequest(url: self.correctUrlWithParameter)
            get.cachePolicy = .useProtocolCachePolicy
            get.httpMethod = "GET"
            get.allHTTPHeaderFields = self.headers
            self.correctGet = get as URLRequest

            let get2 = NSMutableURLRequest(url: self.correctCDNUrlWithParameter)
            get2.cachePolicy = .useProtocolCachePolicy
            get2.httpMethod = "GET"
            get2.allHTTPHeaderFields = self.headers
            self.correctCDNGet = get2 as URLRequest

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

        describe("RequestBuilder") {

            context("When called") {
                it("Builds the passive form request correctly") {
                    let get = RequestBuilder.requestGetPassiveForm(withID: "myformId")
                    expect(get.url?.absoluteString).to(equal("https://api-staging.usabilla.com/live/mobile/app/forms/myformId"))
                    expect(get.cachePolicy).to(equal(self.correctGet.cachePolicy))
                    expect(get.httpMethod).to(equal("GET"))
                    expect(get.allHTTPHeaderFields).to(equal(self.correctGet.allHTTPHeaderFields))
                    expect(get.timeoutInterval).to(equal(10))
                }
                it("Builds the campaign form request correctly") {
                    let get = RequestBuilder.requestGetCampaignForm(withID: "a")
                    expect(get.url?.absoluteString).to(equal("https://sdk.out-staging.usbla.net/forms/a"))
                    expect(get.cachePolicy).to(equal(self.correctGet.cachePolicy))
                    expect(get.httpMethod).to(equal("GET"))
                    expect(get.allHTTPHeaderFields).to(equal(self.correctGet.allHTTPHeaderFields))
                    expect(get.timeoutInterval).to(equal(10))
                }
                it("Builds the campaign list request correctly") {
                    let req = RequestBuilder.requestGetCampaigns(withAppID: "myAppId")
                    expect(req.url?.absoluteString).to(equal("https://sdk.out-staging.usbla.net/campaigns?app_id=myAppId"))
                    expect(req.cachePolicy).to(equal(self.correctPatch.cachePolicy))
                    expect(req.httpMethod).to(equal("GET"))
                    expect(req.timeoutInterval).to(equal(10))
                }
                it("Builds the targeting option request correctly") {
                    let req = RequestBuilder.requestGetTargeting(withID: "targetingID")
                    expect(req.url?.absoluteString).to(equal("https://sdk.out-staging.usbla.net/targeting-options/targetingID"))
                    expect(req.cachePolicy).to(equal(self.correctPatch.cachePolicy))
                    expect(req.httpMethod).to(equal("GET"))
                    expect(req.timeoutInterval).to(equal(10))
                }
                it("Builds the campaign feedback item creation request correctly") {
                    let req = RequestBuilder.requestCampaignFeedbackItemCreation(forCampaignID: "campaignID", withPayload: ["p": "p"])
                    expect(req.url?.absoluteString).to(equal("https://api-staging.usabilla.com/v2/sdk/campaigns/campaignID/feedback"))
                    expect(req.cachePolicy).to(equal(self.correctPost.cachePolicy))
                    expect(req.httpMethod).to(equal(self.correctPost.httpMethod))
                    expect(req.allHTTPHeaderFields).to(equal(self.correctPost.allHTTPHeaderFields))
                    expect(req.timeoutInterval).to(equal(10))
                }
                it("Builds the campaign feedback item patch request correctly") {
                    let req = RequestBuilder.requestCampaignFeedbackItemPatch(forCampaignID: "c", withPayload: ["p": "p"], withSessionToken: "t")
                    expect(req.url?.absoluteString).to(equal("https://api-staging.usabilla.com/v2/sdk/campaigns/c/feedback/t"))
                    expect(req.cachePolicy).to(equal(self.correctPatch.cachePolicy))
                    expect(req.httpMethod).to(equal("PATCH"))
                    expect(req.allHTTPHeaderFields).to(equal(self.correctPost.allHTTPHeaderFields))
                    expect(req.timeoutInterval).to(equal(10))
                }
                it("Builds the increment campaign view request correctly") {
                    let req = RequestBuilder.requestPatchCampaignViews(forCampaignID: "1234", viewCount: 2)
                    expect(req.url?.absoluteString).to(equal("https://api-staging.usabilla.com/v2/sdk/campaigns/1234/views"))
                    expect(req.cachePolicy).to(equal(self.correctPatch.cachePolicy))
                    expect(req.httpMethod).to(equal("PATCH"))
                    expect(req.timeoutInterval).to(equal(10))
                }
                it("Should have the correct header entities") {
                    let requestBuilderHeaders = RequestBuilder.headers
                    expect(requestBuilderHeaders.count).to(equal(self.headers.count))
                    for key in requestBuilderHeaders.keys {
                        expect(requestBuilderHeaders[key]).to(equal(self.headers[key]))
                    }
                }
            }
        }
    }
}
