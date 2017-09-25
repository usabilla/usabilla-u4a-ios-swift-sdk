//
//  ConcreteRuleTests.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 28/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class ConcreteRuleTests: QuickSpec {

    let event1 = Event(name: "event1")
    let event2 = Event(name: "event2")
    let event3 = Event(name: "event3")
    let event4 = Event(name: "event4")

    var leafEvent1: Rule!
    var leafEvent2: Rule!
    var leafEvent3: Rule!
    var leafEvent4: Rule!

    var allPositive: [Rule]!
    var allNegative: [Rule]!
    var mixed: [Rule]!

    override func spec() {

        beforeEach {
            self.leafEvent1 = LeafEvent(event: self.event1, ruleID: "id1", alreadyTriggered: true)
            self.leafEvent2 = LeafEvent(event: self.event2, ruleID: "id2", alreadyTriggered: true)
            self.leafEvent3 = LeafEvent(event: self.event3, ruleID: "id3", alreadyTriggered: false)
            self.leafEvent4 = LeafEvent(event: self.event4, ruleID: "id4", alreadyTriggered: false)
            self.allPositive = [self.leafEvent1, self.leafEvent2]
            self.allNegative = [self.leafEvent3, self.leafEvent4]
            self.mixed = [self.leafEvent1, self.leafEvent2, self.leafEvent3]
        }

        describe("The Concrete Rule") {

            context("The object", {
                it("should initialise correctly") {
                    let or = ConcreteRule(type: .or, childRules: self.mixed)
                    expect(or.type).to(equal(RuleType.or))
                    expect(or.ruleID).toNot(beNil())
                    expect(or.alreadyTriggered).to(beFalse())

                    let and = ConcreteRule(type: .and, childRules: self.mixed, ruleID: "id", alreadyTriggered: true)
                    expect(and.type).to(equal(RuleType.and))
                    expect(and.ruleID).to(equal("id"))
                    expect(and.alreadyTriggered).to(beTrue())

                }

                it("should serialise correctly") {
                    let or = ConcreteRule(type: .and, childRules: self.mixed, ruleID: "id", alreadyTriggered: true)
                    let data = NSKeyedArchiver.archivedData(withRootObject: or)

                    expect(data).toNot(beNil())
                    // swiftlint:disable force_cast
                    let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! ConcreteRule

                    expect(unserialised).toNot(beNil())
                    expect(unserialised.ruleID).to(equal("id"))
                    expect(unserialised.type).to(equal(RuleType.and))
                    expect(unserialised.type).toNot(equal(RuleType.or))

                }

                it("should reset correctly") {
                    let and = ConcreteRule(type: .and, childRules: self.allPositive, ruleID: "id", alreadyTriggered: true)
                    and.reset()
                    expect(and.alreadyTriggered).to(beFalse())
                    expect(and.childRules[0].alreadyTriggered).to(beFalse())
                    expect(and.childRules[1].alreadyTriggered).to(beFalse())
                }

            })

        }
    }
}
