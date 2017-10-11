//
//  UBFeedbackIDDictionaryDAOTests.swift
//  UsabillaTests
//
//  Created by Giacomo Pinato on 19/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UBFeedbackIDDictionaryDAOTests: QuickSpec {

    override func spec() {

        let FeedbackIDsDAO = UBFeedbackIDDictionaryDAO.shared

        beforeEach {
            FeedbackIDsDAO.deleteAll()
        }

        describe("UBFeedbackIDDictionaryDAO") {
            it ("saves a dictionary correctly") {
                let dictionary: NSMutableDictionary = ["a":"a", "b":"b"]
                FeedbackIDsDAO.create(dictionary)
                expect(FeedbackIDsDAO.readAll().count).to(equal(1))
                expect(FeedbackIDsDAO.read(id: UBFeedbackIDDictionaryDAO.dictionaryID)).to(equal(["a":"a", "b":"b"]))
            }
        }
    }
}
