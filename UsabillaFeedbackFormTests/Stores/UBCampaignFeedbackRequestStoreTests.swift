//
//  UBCampaignFeedbackRequestStoreTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 15/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBCampaignFeedbackRequestStoreTests: QuickSpec {

    override func spec() {
        let item1 = UBCampaignFeedbackRequestItem(request: URLRequest(url: URL(string: "https://www.google.nl")!), feedbackId: "id1", type: .start)
        let item2 = UBCampaignFeedbackRequestItem(request: URLRequest(url: URL(string: "https://www.google.nl")!), feedbackId: "id1", type: .page)
        let item3 = UBCampaignFeedbackRequestItem(request: URLRequest(url: URL(string: "https://www.google.nl")!), feedbackId: "id1", type: .page)
        let item4 = UBCampaignFeedbackRequestItem(request: URLRequest(url: URL(string: "https://www.google.nl")!), feedbackId: "id1", type: .close)
        let item5 = UBCampaignFeedbackRequestItem(request: URLRequest(url: URL(string: "https://www.google.nl")!), feedbackId: "id2", type: .close)

        let store = UBCampaignFeedbackRequestStore(campaignDAO: UBCampaignFeedbackRequestDAO())

        beforeEach {
            for item in store.getAll() {
                store.delete(obj: item)
            }
        }

        describe("UBCampaignFeedbackRequestStore") {

            context("when saving an item") {

                it("saves a new item correctly") {
                    store.save(feedbackRequest: item1)
                    let stored = store.getRequest(withFeedbackId: "id1")
                    expect(stored).notTo(beNil())
                    expect(stored!.id).to(equal("id1"))
                    expect(stored!.items.count).to(equal(1))
                }

                it("appends a request to an existing item correctly") {
                    store.save(feedbackRequest: item1)
                    store.save(feedbackRequest: item2)
                    let stored = store.getRequest(withFeedbackId: "id1")
                    let all = store.getAll()
                    expect(all.count).to(equal(1))
                    expect(stored).notTo(beNil())
                    expect(stored!.id).to(equal("id1"))
                    expect(stored!.items.count).to(equal(2))
                }

                it("saves two different new items correctly") {
                    store.save(feedbackRequest: item1)
                    store.save(feedbackRequest: item5)
                    let all = store.getAll()
                    expect(all.count).to(equal(2))
                }
            }

            context("when retrieving an item") {

                it("correctly orders the request of a complete item") {
                    store.save(feedbackRequest: item2)
                    store.save(feedbackRequest: item1)
                    store.save(feedbackRequest: item4)
                    store.save(feedbackRequest: item3)
                    let stored = store.getRequest(withFeedbackId: "id1")
                    expect(stored!.items.count).to(equal(4))
                    expect(stored!.items[0].type).to(equal(RequestType.start))
                    expect(stored!.items[1].type).to(equal(RequestType.page))
                    expect(stored!.items[2].type).to(equal(RequestType.page))
                    expect(stored!.items[3].type).to(equal(RequestType.close))
                }

                it("correctly orders the request of a partial item") {
                    store.save(feedbackRequest: item2)
                    store.save(feedbackRequest: item4)
                    store.save(feedbackRequest: item3)
                    let stored = store.getRequest(withFeedbackId: "id1")
                    expect(stored!.items.count).to(equal(3))
                    expect(stored!.items[0].type).to(equal(RequestType.page))
                    expect(stored!.items[1].type).to(equal(RequestType.page))
                    expect(stored!.items[2].type).to(equal(RequestType.close))
                }
            }

            it("correctly deletes an item") {
                store.save(feedbackRequest: item1)
                store.delete(id: "id1")
                expect(store.getRequest(withFeedbackId: "id1")).to(beNil())
                expect(store.getAll()).to(beEmpty())
            }
        }
    }
}
