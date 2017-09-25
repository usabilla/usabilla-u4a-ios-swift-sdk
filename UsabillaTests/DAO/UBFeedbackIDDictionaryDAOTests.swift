//
//  UBFeedbackIDDictionaryDAOTests.swift
//  UsabillaFeedbackFormTests
//
//  Created by Giacomo Pinato on 19/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UBFeedbackIDDictionaryDAOTests: QuickSpec {

    override func spec() {

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootUrl = documentsDirectory.appendingPathComponent("UBSDK")
        let directoryUrl = rootUrl.appendingPathComponent(UBFeedbackIDDictionaryDAO.directoryName)

        let store = UBFeedbackIDDictionaryDAO.shared

        beforeEach {
            store.deleteAll()
        }

        describe("the UBFeedbackIDDictionaryDAO") {
            it ("saves a dictionary correctly") {
                let dictionary: NSMutableDictionary = ["a":"a", "b":"b"]
                store.create(dictionary)
                expect(store.readAll().count).to(equal(1))
                expect(store.read(id: UBFeedbackIDDictionaryDAO.dictionaryID)).to(equal(["a":"a", "b":"b"]))
            }
        }
    }
}
