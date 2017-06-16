//
//  UBCampaignFeedbackRequestTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 21/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBCampaignFeedbackRequestTests: QuickSpec {

    override func spec() {
        describe("UBCampaignFeedbackRequest") {
            it("Creates object with different id") {
                var items: [UBCampaignFeedbackRequest] = []

                for _ in 0...2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        items.append(UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!)))
                    })

                }

                expect(items.count).toEventually(equal(3), timeout: 4)
                expect(items[0]).notTo(equal(items[1]))
                expect(items[0]).notTo(equal(items[2]))
                expect(items[1]).notTo(equal(items[2]))
            }
        }
    }
}
