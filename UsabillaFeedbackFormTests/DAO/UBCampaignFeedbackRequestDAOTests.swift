//
//  UBCampaignFeedbackRequestDAOTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 15/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBCampaignFeedbackRequestDAOTests: QuickSpec {

    override func spec() {

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootUrl = documentsDirectory.appendingPathComponent("UBSDK")
        let directoryUrl = rootUrl.appendingPathComponent(UBCampaignFeedbackRequestDAO.directoryName)

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
                    let feedbackRequest = UBCampaignFeedbackRequest(id: "id", items: [])
                    let id = UBCampaignFeedbackRequestDAO.shared.id(forObj: feedbackRequest)
                    expect(id).to(equal(feedbackRequest.id))
                }
            }
        }
    }
}
