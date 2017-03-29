//
//  EventTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class EventTest: QuickSpec {

    override func spec() {

        describe("And event") {

            it("Is initialised correctly") {
                let event1 = Event(name: "event1")
                expect(event1.name).to(equal("event1"))
            }


            it("prints itself correctly") {
                let event1 = Event(name: "event1")
                expect(event1.toString()).to(equal("event1"))
            }

            it("compares correctly") {
                let event1 = Event(name: "event1")
                let event2 = Event(name: "event2")
                expect(event1 == event2).to(beFalse())
                expect(event1 == event1).to(beTrue())
                expect(event1 != event2).to(beTrue())

            }
            
            it("serialises correctly") {
                let event1 = Event(name: "event1")
                
                let data = NSKeyedArchiver.archivedData(withRootObject: event1)
                
                expect(data).toNot(beNil())
                // swiftlint:disable force_cast
                let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! Event
                expect(unserialised.name).to(equal("event1"))

            }

        }
    }
}
