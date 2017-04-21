//
//  RequestBuilderTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class RequestBuilderTest: QuickSpec {

    var correctUrl: URL!
    var correctUrlWithParameter: URL!
    var correctGet: URLRequest!
    var correctPost: URLRequest!
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
        }

        describe("The Request builder") {
            it("Builds the campaign form request correctly") {
                let get = RequestBuilder.buildGetCampaignForm(withFormId: "a")
                expect(get.url?.absoluteString).to(equal("https://api-staging.usabilla.com/v2/sdk/forms/a"))
                expect(get.cachePolicy).to(equal(self.correctGet.cachePolicy))
                expect(get.httpMethod).to(equal(self.correctGet.httpMethod))
                expect(get.allHTTPHeaderFields).to(equal(self.correctGet.allHTTPHeaderFields))
            }
        }

    }
}
