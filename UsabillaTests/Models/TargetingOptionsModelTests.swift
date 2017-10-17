//
//  TargetingOptionsModelTests.swift
//  UsabillaTests
//
//  Created by Giacomo Pinato on 18/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class TargetingOptionsModelTests: QuickSpec {

    override func spec() {

        let jsonString = "{\"id\": \"eca84024-6db0-4a3d-b620-ffdcee03e677\", \"last_modified_at\": \"2017-05-04T15:22:59.000Z\" , \"options\": {\"rule\": {\"type\": \"repetition\",\"repetition\": 2, \"children\": [{\"type\": \"event\",\"name\": \"pizza\"}]}}}"
        let json = JSON(parseJSON: jsonString)
        let lastModified = "2017-05-04T15:22:59.000Z".dateFromRFC3339

        describe("The TargetingOptionsModel") {
            context("when initialising"){
                it("should initialise correctly with valid json") {
                    let targeting = TargetingOptionsModel(json: json)
                    expect(targeting).notTo(beNil())
                    expect(targeting?.targetingID).to(equal("eca84024-6db0-4a3d-b620-ffdcee03e677"))
                    expect(targeting?.lastModifiedDate).to(equal(lastModified))
                    expect(targeting?.rule).notTo(beNil())
                }
                it("should fail initialising with json without id") {
                    let jsonString = "{\"last_modified_at\": \"2017-05-04T15:22:59.000Z\" , \"options\": {\"rule\": {\"type\": \"repetition\",\"repetition\": 2, \"children\": [{\"type\": \"event\",\"name\": \"pizza\"}]}}}"
                    let json = JSON(parseJSON: jsonString)
                    let targeting = TargetingOptionsModel(json: json)
                    expect(targeting).to(beNil())
                }
                it("should fail initialising with json without targeting") {
                    let jsonString = "{\"id\": \"eca84024-6db0-4a3d-b620-ffdcee03e677\",\"last_modified_at\": \"2017-05-04T15:22:59.000Z\"}"
                    let json = JSON(parseJSON: jsonString)
                    let targeting = TargetingOptionsModel(json: json)
                    expect(targeting).to(beNil())
                }
                it("should fail initialising with json without valid date") {
                    let jsonString = "{\"id\": \"eca84024-6db0-4a3d-b620-ffdcee03e677\", \"last_modified_at\": \"2017-05-04T15:222:59.000Z\" , \"options\": {\"rule\": {\"type\": \"repetition\",\"repetition\": 2, \"children\": [{\"type\": \"event\",\"name\": \"pizza\"}]}}}"
                    let json = JSON(parseJSON: jsonString)
                    let targeting = TargetingOptionsModel(json: json)
                    expect(targeting).notTo(beNil())
                    expect(targeting?.targetingID).to(equal("eca84024-6db0-4a3d-b620-ffdcee03e677"))
                    expect(targeting?.lastModifiedDate).to(beNil())
                    expect(targeting?.rule).notTo(beNil())
                }
            }

            it("should serialise and userialise correctly") {
                let targeting = TargetingOptionsModel(json: json)
                let data = NSKeyedArchiver.archivedData(withRootObject: targeting)

                expect(data).toNot(beNil())
                // swiftlint:disable force_cast
                let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! TargetingOptionsModel

                expect(unserialised).notTo(beNil())
                expect(unserialised.targetingID).to(equal("eca84024-6db0-4a3d-b620-ffdcee03e677"))
                expect(unserialised.lastModifiedDate).to(equal(lastModified))
                expect(unserialised.rule).notTo(beNil())
            }
        }
    }
}
