//
//  LeafEventTests.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class LeafEventTests: QuickSpec {

    let event1 = Event(name: "event1")
    let event2 = Event(name: "event2")
    var activeStatuses: [String: String] = [String: String]()

    override func spec() {
        describe("The Leaf Rule") {

            context("When creating an object", {
                it("should initialise correctly") {
                    let leaf = LeafEvent(event: self.event1, ruleID: "id", alreadyTriggered: false)
                    expect(leaf.type).to(equal(RuleType.event))
                    expect(leaf.alreadyTriggered).to(beFalse())
                    expect(leaf.childRules).to(beEmpty())
                }
            })

            context("When initilized from JSON") {
                it("should fail if it does not have name") {
                    let leafEventJson = UBMock.json("LeafRuleNoEventName")
                    let decorator = LeafEvent(json: leafEventJson!)
                    expect(decorator).to(beNil())
                }
                it("should succeed if json is correct") {
                    let leafEventJson = UBMock.json("LeafRuleCorrect")
                    let rule = LeafEvent(json: leafEventJson!)
                    expect(rule).toNot(beNil())
                    expect(rule?.type).to(equal(RuleType.event))
                    let event = Event(name: "purchaseComplete")
                    expect(rule?.triggersWith(event: event, activeStatuses: self.activeStatuses)).to(beTrue())
                }
            }

            context("When checking for validity", {
                it("should trigger if the event matched") {
                    let leaf = LeafEvent(event: self.event1, ruleID: "id", alreadyTriggered: false)
                    expect(leaf.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())
                    expect(leaf.alreadyTriggered).to(beTrue())

                }

                it("should not trigger if the event do not match") {
                    let leaf = LeafEvent(event: self.event1, ruleID: "id", alreadyTriggered: false)
                    expect(leaf.triggersWith(event: self.event2, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(leaf.alreadyTriggered).to(beFalse())

                }
            })
        }
    }
}
