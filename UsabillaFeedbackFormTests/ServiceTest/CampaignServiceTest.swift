//
//  CampaignServiceTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaignServiceTest: QuickSpec {
    override func spec() {
        describe("The Campaign Service") {
            it("Handles a success callback correctly") {
                waitUntil(timeout: 2.0) { done in
                    CampaignService(httpClient: UBHTTPMockSuccess.self).getCampaignForm(withId: "a").then { _ in
                        done()
                    }.catch { _ in
                        fail("should not go here")
                    }
                }
            }
            it("Handles a failing callback correctly") {
                waitUntil(timeout: 2.0) { done in
                    CampaignService(httpClient: UBHTTPMockFail.self).getCampaignForm(withId: "a").then { _ in
                        fail("should not go here")
                    }.catch { _ in
                        done()
                    }
                }
            }
        }
    }
}
