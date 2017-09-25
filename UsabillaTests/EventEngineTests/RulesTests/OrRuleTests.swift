//
//  OrRuleTests.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class OrRuleTests: QuickSpec {
    var activeStatuses: [String: String] = [String: String]()

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

        describe("The Or Rule") {

            context("When creating an object", {
                it("should initialise correctly") {
                    let or = OrRule(childRules: [self.leafEvent1])
                    expect(or.type).to(equal(RuleType.or))
                    expect(or.alreadyTriggered).to(beFalse())

                }
            })

            context("when checking for validity", {
                it("should return true if any of the children is satisfied") {
                    var or = OrRule(childRules: self.allPositive)
                    expect(or.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())

                    or = OrRule(childRules: self.mixed)
                    expect(or.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beTrue())

                    or = OrRule(childRules: self.allNegative)
                    expect(or.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beTrue())
                }

                it("should return false if all children are not satisfied") {
                    let or = OrRule(childRules: self.allNegative)
                    expect(or.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())

                }
            })

        }
    }
}
