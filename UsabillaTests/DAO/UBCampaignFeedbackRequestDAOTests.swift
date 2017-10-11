//
//  UBCampaignFeedbackRequestDAOTests.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 15/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble
// swiftlint:disable function_body_length
@testable import Usabilla

class UBCampaignFeedbackRequestDAOTests: QuickSpec {

    override func spec() {

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootUrl = documentsDirectory.appendingPathComponent("UBSDK")
        let directoryUrl = rootUrl.appendingPathComponent(UBCampaignFeedbackRequestDAO.directoryName.rawValue)

        let item1 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), internalID: "internalID", id: "1498039389940")
        let item2 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), internalID: "internalID", id: "1498039389950")
        let item3 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), internalID: "internalID", id: "1498039389960")
        let item4 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), internalID: "internalID", id: "1498039389970")
        let item5 = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), internalID: "internalID", id: "1498039389980")

        let store = UBCampaignFeedbackRequestDAO.shared

        beforeEach {
            store.deleteAll()
        }

        describe("UBCampaignFeedbackRequestDAO") {
            context("when directory is created") {
                it("should have created the directory") {
                    try? FileManager.default.removeItem(at: directoryUrl)
                    var exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beFalse())

                    UBFileHelper.createDirectory(url: directoryUrl)

                    exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beTrue())
                    expect(directoryUrl.lastPathComponent).to(equal("UBCampaignFeedbackRequest"))
                }
            }

            context("when requesting an id") {
                it("should return the correct id") {
                    let feedbackRequest = UBCampaignFeedbackRequest(request: URLRequest(url: URL(string: "https://www.google.nl")!), internalID: "internalID")
                    let id = UBCampaignFeedbackRequestDAO.shared.id(forObj: feedbackRequest)
                    expect(id).to(equal(feedbackRequest.id))
                }
            }

            context("when saving an item") {

                it("saves a new item correctly") {
                    store.create(item1)
                    let stored = store.readAll()
                    expect(stored).notTo(beNil())
                    expect(stored.count).to(equal(1))
                }

                it("saves two different new items correctly") {
                    store.create(item1)
                    store.create(item5)
                    let all = store.readAll()
                    expect(all.count).to(equal(2))
                    expect(all[0].id).notTo(equal(all[1].id))
                }
            }

            context("when retrieving an item") {

                it("correctly orders the request of a complete item") {
                    store.create(item2)
                    store.create(item1)
                    store.create(item4)
                    store.create(item3)
                    let stored = store.readAll()
                    let ids = stored.map { $0.id }
                    expect(ids).to(equal([item1.id, item2.id, item3.id, item4.id]))
                }
            }

            context("when deleting an item") {

                it("correctly deletes an item with an id") {
                    store.create(item1)
                    store.delete(item1)
                    expect(store.read(id: "id1")).to(beNil())
                    //expect(store.read).to(beEmpty())
                }

                it("correctly deletes an item with a UBCampaignFeedbackRequest") {
                    store.create(item1)
                    store.delete(item1)
                    expect(store.read(id: "id1")).to(beNil())
                    expect(store.readAll()).to(beEmpty())
                }
            }
        }
    }
}
