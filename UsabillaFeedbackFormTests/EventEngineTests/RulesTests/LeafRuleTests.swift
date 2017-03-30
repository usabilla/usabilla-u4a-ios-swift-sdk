//
//  LeafRuleTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class LeafRuleTests: QuickSpec {

    let event1 = Event(name: "event1")
    let event2 = Event(name: "event2")

    override func spec() {


        describe("The Leaf Rule") {

            context("When creating an object", {
                it("should initialise correctly") {
                    let leaf = LeafRule(event: self.event1, ruleID: "id", alreadyTriggered: false)
                    expect(leaf.type).to(equal(RuleType.leaf))
                    expect(leaf.alreadyTriggered).to(beFalse())
                    expect(leaf.childRules).to(beEmpty())
                }
            })

            context("When checking for validity", {
                it("should trigger if the event matched") {
                    let leaf = LeafRule(event: self.event1, ruleID: "id", alreadyTriggered: false)
                    expect(leaf.triggersWith(event: self.event1)).to(beTrue())
                    expect(leaf.alreadyTriggered).to(beTrue())

                }
                
                it("should not trigger if the event do not match") {
                    let leaf = LeafRule(event: self.event1, ruleID: "id", alreadyTriggered: false)
                    expect(leaf.triggersWith(event: self.event2)).to(beFalse())
                    expect(leaf.alreadyTriggered).to(beFalse())

                }
            })


        }
    }
}
