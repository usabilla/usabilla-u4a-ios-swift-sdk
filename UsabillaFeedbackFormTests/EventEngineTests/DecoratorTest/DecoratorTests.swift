//
//  DecoratorTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class DecoratorTests: QuickSpec {

    let event1 = Event(name: "event1")

    var leafRule1: Rule!

    override func spec() {

        beforeEach {
            self.leafRule1 = LeafRule(event: self.event1, ruleID: "id1", alreadyTriggered: true)
        }

        describe("The base Decorator") {

            context("When creating an object") {
                it("should initialise correctly") {
                    let decorator = Decorator(rule: self.leafRule1)
                    expect(decorator.type).to(equal(RuleType.leaf))
                    expect(decorator.ruleID).to(equal("id1"))
                    expect(decorator.rule).to(be(self.leafRule1))
                    expect(decorator.alreadyTriggered).to(beFalse())
                    expect(decorator.childRules.count).to(equal(1))
                    expect(decorator.childRules.first!).to(be(self.leafRule1))
                }
            }

            it("should serialize correctly") {
                let decorator = Decorator(rule: self.leafRule1)
                let data = NSKeyedArchiver.archivedData(withRootObject: decorator)

                expect(data).toNot(beNil())
                // swiftlint:disable force_cast
                let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! Decorator

                expect(unserialised.type).to(equal(RuleType.leaf))
                expect(unserialised.ruleID).to(equal("id1"))
                expect(unserialised.rule).to(beAKindOf(LeafRule.self))
                expect(unserialised.rule.ruleID).to(equal("id1"))
                expect(unserialised.alreadyTriggered).to(beFalse())
                expect(decorator.childRules.count).to(equal(1))
                expect(decorator.childRules.first!).to(be(self.leafRule1))
            }

            context("When calling responds to event") {
                it ("Should succeed when the rule responds to the event") {
                    let decorator = Decorator(rule: self.leafRule1)
                    let event = Event(name: "event1")
                    expect(decorator.respondsToEvent(event: event)).to(beTrue())
                }

                it ("Should fail when the rule does not respond to the event") {
                    let decorator = Decorator(rule: self.leafRule1)
                    let event = Event(name: "event2")
                    expect(decorator.respondsToEvent(event: event)).to(beFalse())
                }
            }
        }
    }
}
