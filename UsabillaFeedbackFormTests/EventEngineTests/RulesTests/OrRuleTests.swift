//
//  OrRuleTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class OrRuleTests: QuickSpec {

    let event1 = Event(name: "event1")
    let event2 = Event(name: "event2")
    let event3 = Event(name: "event3")
    let event4 = Event(name: "event4")

    var leafRule1: Rule!
    var leafRule2: Rule!
    var leafRule3: Rule!
    var leafRule4: Rule!

    var allPositive: [Rule]!
    var allNegative: [Rule]!
    var mixed: [Rule]!


    override func spec() {

        beforeEach {
            self.leafRule1 = LeafRule(event: self.event1, ruleID: "id1", alreadyTriggered: true)
            self.leafRule2 = LeafRule(event: self.event2, ruleID: "id2", alreadyTriggered: true)
            self.leafRule3 = LeafRule(event: self.event3, ruleID: "id3", alreadyTriggered: false)
            self.leafRule4 = LeafRule(event: self.event4, ruleID: "id4", alreadyTriggered: false)


            self.allPositive = [self.leafRule1, self.leafRule2]
            self.allNegative = [self.leafRule3, self.leafRule4]
            self.mixed = [self.leafRule1, self.leafRule2, self.leafRule3]
        }


        describe("The Or Rule") {

            context("When creating an object", {
                it("should initialise correctly") {
                    let or = OrRule(childRules: [self.leafRule1])
                    expect(or.type).to(equal(RuleType.or))
                    expect(or.alreadyTriggered).to(beFalse())

                }
            })



            context("when checking for validity", {
                it("should return true if any of the children is satisfied") {
                    var or = OrRule(childRules: self.allPositive)
                    expect(or.triggersWith(event: self.event1)).to(beTrue())

                    or = OrRule(childRules: self.mixed)
                    expect(or.triggersWith(event: self.event4)).to(beTrue())

                    or = OrRule(childRules: self.allNegative)
                    expect(or.triggersWith(event: self.event4)).to(beTrue())
                }

                it("should return false if all children are not satisfied") {
                    let or = OrRule(childRules: self.allNegative)
                    expect(or.triggersWith(event: self.event1)).to(beFalse())

                }
            })

        }
    }
}
