//
//  AndRuleTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 28/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class AndRuleTests: QuickSpec {

    let event1 = Event(name: "event1")
    let event2 = Event(name: "event2")
    let event3 = Event(name: "event3")
    let event4 = Event(name: "event4")

    var leafEvent1: Rule!
    var leafEvent2: Rule!
    var leafEvent3: Rule!
    var leafEvent4: Rule!
    var activeStatuses: [String: String] = [String: String]()
    
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

        describe("The And Rule") {

            context("When creating an object") {
                it("should initialise correctly") {
                    let newAnd = AndRule(childRules: [self.leafEvent1])
                    expect(newAnd.type).to(equal(RuleType.and))
                    expect(newAnd.alreadyTriggered).to(beFalse())

                }
            }
            
            context("When initilized from JSON") {
                it("should fail if it does not have type") {
                    let andJson = UBMock.json("AndRule")?["WithoutType"]
                    let rule = AndRule(json: andJson!)
                    expect(rule).to(beNil())
                }
                it("should succeed if json is correct") {
                    let andJson = UBMock.json("AndRule")?["Correct"]
                    let rule = AndRule(json: andJson!)
                    expect(rule).toNot(beNil())
                    expect(rule?.type).to(equal(RuleType.and))
                    expect(rule?.childRules.count).to(equal(2))
                }
            }

            context("when checking for validity") {
                it("should return true if all children is satisfied") {
                    let newAnd = AndRule(childRules: self.allPositive)
                    expect(newAnd.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())
                    expect(newAnd.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beTrue())

                    let newAnd2 = AndRule(childRules: self.mixed)
                    expect(newAnd2.triggersWith(event: self.event3, activeStatuses: self.activeStatuses)).to(beTrue())
                }

                it("should return false if even one children is not satisfied") {

                    let newAnd2 = AndRule(childRules: self.mixed)
                    expect(newAnd2.triggersWith(event: self.event2, activeStatuses: self.activeStatuses)).to(beFalse())
                }

                it("should progress correctly") {
                    let newAnd2 = AndRule(childRules: self.allNegative)
                    expect(newAnd2.triggersWith(event: self.event2, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(newAnd2.triggersWith(event: self.event3, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(newAnd2.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(newAnd2.triggersWith(event: self.event4, activeStatuses: self.activeStatuses)).to(beTrue())

                }
            }

        }
    }
}
