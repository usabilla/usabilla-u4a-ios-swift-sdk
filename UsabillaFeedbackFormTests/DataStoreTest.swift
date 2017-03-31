//
//  ManagersTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

// swiftlint:disable force_cast
class DataStoreTest: QuickSpec {



    override func spec() {

        let feedbackToSendStorePath = "com.usabilla.u4a.feedback.to.send"

        var feedback1: FeedbackRequest!
        var feedback2: FeedbackRequest!
        var feedback3: FeedbackRequest!

        beforeSuite {


            let payload: [String: Any] = ["key1": "value1", "key2": "value2"]
            let payload2: [String: Any] = ["key12": "value12", "key22": "value22"]

            let screenshot: String = "dawbfibwfbqeklbf;ewbfio;weiogioewbgoiewig'weOGNEWgw"

            feedback1 = FeedbackRequest(payload: payload, screenshot: screenshot)
            feedback2 = FeedbackRequest(payload: payload, screenshot: nil)
            feedback3 = FeedbackRequest(payload: payload2, screenshot: nil)

            let tempFeedback = [feedback1, feedback2]

            UserDefaults.standard.set(tempFeedback.map { $0?.encode() }, forKey: feedbackToSendStorePath)

        }

        describe("the DataStore object") {

            it("is correctly initialised") {
                expect(DataStore.feedbacks.count).to(equal(2))
            }


            it("adds a feeback correctly") {
                DataStore.addFeedback(type: feedback3!)
                expect(DataStore.feedbacks.count).to(equal(3))
            }

            it("stores a feedback correctly") {
                let storedFeedbacks = UserDefaults.standard.value(forKey: feedbackToSendStorePath) as! [[String: AnyObject]]
                let dbFeedbacks = storedFeedbacks.map { FeedbackRequest(data: $0) }

                expect(dbFeedbacks.count).to(equal(3))
                let value = dbFeedbacks[2].payload["key12"] as! String
                expect(value).to(equal("value12"))
                expect(dbFeedbacks[2].screenshot).to(beNil())

            }


            it("removes a feeback correctly") {
                DataStore.removeFeedback(index: 0)
                expect(DataStore.feedbacks.count).to(equal(2))
            }

            it("deletes a feedback correctly") {
                let storedFeedbacks = UserDefaults.standard.value(forKey: feedbackToSendStorePath) as! [[String: AnyObject]]
                let dbFeedbacks = storedFeedbacks.map { FeedbackRequest(data: $0) }

                expect(dbFeedbacks.count).to(equal(2))
                let value = dbFeedbacks[1].payload["key12"] as! String
                expect(value).to(equal("value12"))
                expect(dbFeedbacks[1].screenshot).to(beNil())

            }
        }
    }
}
