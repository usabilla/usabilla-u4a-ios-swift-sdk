//
//  SequenceRuleTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class SequenceRuleTest: QuickSpec {

    let event1 = Event(name: "event1")
    let event2 = Event(name: "event2")
    let event3 = Event(name: "event3")
    let event4 = Event(name: "event4")

    var leafRule1: Rule!
    var leafRule2: Rule!
    var leafRule3: Rule!
    var leafRule4: Rule!

    var children: [Rule]!


    override func spec() {

        beforeEach {
            self.leafRule1 = LeafRule(event: self.event1, ruleID: "id1", alreadyTriggered: false)
            self.leafRule2 = LeafRule(event: self.event2, ruleID: "id2", alreadyTriggered: false)
            self.leafRule3 = LeafRule(event: self.event3, ruleID: "id3", alreadyTriggered: false)
            self.leafRule4 = LeafRule(event: self.event4, ruleID: "id4", alreadyTriggered: false)

            self.children = [self.leafRule1, self.leafRule2, self.leafRule3, self.leafRule4]
        }


        describe("The Sequence Rule") {

            context("When creating an object", {
                it("should initialise correctly") {
                    let sequence = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence.type).to(equal(RuleType.sequence))
                    expect(sequence.alreadyTriggered).to(beFalse())

                }
            })

            context("when checking for validity", {
                it("should trigger with the right sequence") {
                    let sequence = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence.triggersWith(event: self.event1)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event2)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event3)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event4)).to(beTrue())

                }

                it("should not trigger with the wrong sequence") {
                    let sequence = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence.triggersWith(event: self.event4)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event1)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event2)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event3)).to(beFalse())

                }

                it("should not trigger with the wrong sequence") {
                    let sequence2 = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence2.triggersWith(event: self.event1)).to(beFalse())
                    expect(sequence2.triggersWith(event: self.event2)).to(beFalse())
                    expect(sequence2.triggersWith(event: self.event4)).to(beFalse())
                    expect(sequence2.triggersWith(event: self.event3)).to(beFalse())

                }

                it("should not trigger with the wrong sequence") {
                    let sequence3 = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence3.triggersWith(event: self.event2)).to(beFalse())
                    expect(sequence3.triggersWith(event: self.event4)).to(beFalse())
                    expect(sequence3.triggersWith(event: self.event1)).to(beFalse())
                    expect(sequence3.triggersWith(event: self.event3)).to(beFalse())

                }

                it("should only consider the first unsatisfied child") {
                    let sequence = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence.triggersWith(event: self.event4)).to(beFalse())
                    expect(self.leafRule4.alreadyTriggered).to(beFalse())
                    
                    expect(sequence.triggersWith(event: self.event1)).to(beFalse())
                    expect(self.leafRule1.alreadyTriggered).to(beTrue())

                }


            })




        }
    }
}
