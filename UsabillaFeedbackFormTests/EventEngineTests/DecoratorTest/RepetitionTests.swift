//
//  RepetitionTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class RepetitionRuleTests: QuickSpec {

    let event1 = Event(name: "event1")

    var leafRule1: Rule!

    override func spec() {

        beforeEach {
            self.leafRule1 = LeafRule(event: self.event1, ruleID: "id1", alreadyTriggered: true)
        }

        describe("The Repetition Decorator") {

            context("When creating an object", {
                it("should initialise correctly") {
                    let rep = RepetitionDecorator(occurrences: 5, rule: self.leafRule1)
                    expect(rep.type).to(equal(RuleType.leaf))
                    expect(rep.ruleID).to(equal("id1"))
                    expect(rep.rule).to(be(self.leafRule1))
                    expect(rep.alreadyTriggered).to(beFalse())

                }
            })

            context("When checking for validity", {
                it("should trigger only after the correct number of repetition") {
                    let rep = RepetitionDecorator(occurrences: 5, rule: self.leafRule1)
                    expect(rep.alreadyTriggered).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beTrue())
                    expect(rep.alreadyTriggered).to(beTrue())

                }

                it("should trigger even when the number of occurrences surpasses the threshold") {
                    let rep = RepetitionDecorator(occurrences: 2, rule: self.leafRule1)
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.alreadyTriggered).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beTrue())
                    expect(rep.triggersWith(event: self.event1)).to(beTrue())
                    expect(rep.triggersWith(event: self.event1)).to(beTrue())
                    expect(rep.triggersWith(event: self.event1)).to(beTrue())
                    expect(rep.alreadyTriggered).to(beTrue())

                }

                it("should serialize correctly") {
                    let rep = RepetitionDecorator(occurrences: 5, rule: self.leafRule1)
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())

                    let data = NSKeyedArchiver.archivedData(withRootObject: rep)

                    expect(data).toNot(beNil())
                    // swiftlint:disable force_cast
                    let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! RepetitionDecorator

                    expect(unserialised.type).to(equal(RuleType.leaf))
                    expect(unserialised.ruleID).to(equal("id1"))
                    expect(unserialised.rule).to(beAKindOf(LeafRule.self))
                    expect(unserialised.rule.ruleID).to(equal("id1"))
                    expect(unserialised.alreadyTriggered).to(beFalse())
                    expect(unserialised.currentCount).to(equal(2))
                    expect(unserialised.occurrences).to(equal(5))

                    expect(unserialised.triggersWith(event: self.event1)).to(beFalse())
                    expect(unserialised.triggersWith(event: self.event1)).to(beFalse())
                    expect(unserialised.triggersWith(event: self.event1)).to(beTrue())

                }

                it("should trigger only after the correct number of repetition") {
                    let rep = RepetitionDecorator(occurrences: 5, rule: self.leafRule1)
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1)).to(beTrue())

                }
            })
        }
    }
}
