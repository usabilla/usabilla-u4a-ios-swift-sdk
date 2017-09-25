//
//  SequenceRuleTests.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

class SequenceRuleTests: QuickSpec {

    let event1 = Event(name: "event1")
    let event2 = Event(name: "event2")
    let event3 = Event(name: "event3")
    let event4 = Event(name: "event4")

    var leafEvent1: Rule!
    var leafEvent2: Rule!
    var leafEvent3: Rule!
    var leafEvent4: Rule!
    
    var activeStatuses: [String: String] = [String: String]()

    var children: [Rule]!
    override func spec() {

        beforeEach {
            self.leafEvent1 = LeafEvent(event: self.event1, ruleID: "id1", alreadyTriggered: false)
            self.leafEvent2 = LeafEvent(event: self.event2, ruleID: "id2", alreadyTriggered: false)
            self.leafEvent3 = LeafEvent(event: self.event3, ruleID: "id3", alreadyTriggered: false)
            self.leafEvent4 = LeafEvent(event: self.event4, ruleID: "id4", alreadyTriggered: false)

            self.children = [self.leafEvent1, self.leafEvent2, self.leafEvent3, self.leafEvent4]
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
                    expect(sequence.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event2, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event3, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beTrue())

                }

                it("should trigger with the right sequence even if it is not sequential") {
                    let sequence = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event3, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event3, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event2, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event3, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event2, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beTrue())

                }

                it("should not trigger with the wrong sequence") {
                    let sequence = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event2, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence.triggersWith(event: self.event3, activeStatuses: self.activeStatuses)).to(beFalse())

                }

                it("should not trigger with the wrong sequence") {
                    let sequence2 = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence2.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence2.triggersWith(event: self.event2, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence2.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence2.triggersWith(event: self.event3, activeStatuses: self.activeStatuses)).to(beFalse())

                }

                it("should not trigger with the wrong sequence") {
                    let sequence3 = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence3.triggersWith(event: self.event2, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence3.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence3.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence3.triggersWith(event: self.event3, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(sequence3.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beFalse())

                }

                it("should only consider the first unsatisfied child") {
                    let sequence = SequenceRule(childRules: self.children, ruleID: "id", alreadyTriggered: false)
                    expect(sequence.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(self.leafEvent4.alreadyTriggered).to(beFalse())

                    expect(sequence.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(self.leafEvent1.alreadyTriggered).to(beTrue())

                }
            })

        }
    }
}
