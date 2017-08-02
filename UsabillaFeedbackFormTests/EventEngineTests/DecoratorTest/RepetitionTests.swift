//
//  RepetitionTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 29/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class RepetitionRuleTests: QuickSpec {

    let event1 = Event(name: "event1")
    var leafEvent1: Rule!
    var activeStatuses: [String: String] = [String: String]()

    override func spec() {

        beforeEach {
            self.leafEvent1 = LeafEvent(event: self.event1, ruleID: "id1", alreadyTriggered: true)
        }

        describe("The Repetition Decorator") {

            context("When creating an object") {
                it("should initialise correctly") {
                    let rep = RepetitionDecorator(occurrences: 5, rule: self.leafEvent1)
                    expect(rep.type).to(equal(RuleType.leaf))
                    expect(rep.ruleID).to(equal("id1"))
                    expect(rep.rule).to(be(self.leafEvent1))
                    expect(rep.alreadyTriggered).to(beFalse())
                }
            }

            context("When initilized from JSON") {
                it("should fail if it does not have any children") {
                    let percentageJsonNoChilderen = UBMock.json("RepetitionDecoratorNoChildren")?["rule"]
                    let decorator = RepetitionDecorator(json: percentageJsonNoChilderen!)
                    expect(decorator).to(beNil())
                }
                it("should fail if it does not have repetition") {
                    let repetitionJsonNoRepetition = UBMock.json("RepetitionDecoratorNoRepetition")?["rule"]
                    let decorator = RepetitionDecorator(json: repetitionJsonNoRepetition!)
                    expect(decorator).to(beNil())
                }
                it("should succeed if json is correct") {
                    let percentageJsonCorrect = UBMock.json("RepetitionDecoratorCorrect")?["rule"]
                    let decorator = RepetitionDecorator(json: percentageJsonCorrect!)
                    expect(decorator).toNot(beNil())
                    expect(decorator?.currentCount).to(equal(0))
                    expect(decorator?.occurrences).to(equal(13))
                }
            }

            context("When checking for validity") {
                it("should trigger only after the correct number of repetition") {
                    let rep = RepetitionDecorator(occurrences: 5, rule: self.leafEvent1)
                    expect(rep.alreadyTriggered).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())
                    expect(rep.alreadyTriggered).to(beTrue())
                }
                it("should trigger even when the number of occurrences surpasses the threshold") {
                    let rep = RepetitionDecorator(occurrences: 2, rule: self.leafEvent1)
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.alreadyTriggered).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())
                    expect(rep.alreadyTriggered).to(beTrue())
                }
                it("should serialize correctly") {
                    let rep = RepetitionDecorator(occurrences: 5, rule: self.leafEvent1)
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())

                    let data = NSKeyedArchiver.archivedData(withRootObject: rep)

                    expect(data).toNot(beNil())
                    // swiftlint:disable force_cast
                    let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! RepetitionDecorator

                    expect(unserialised.type).to(equal(RuleType.leaf))
                    expect(unserialised.ruleID).to(equal("id1"))
                    expect(unserialised.rule).to(beAKindOf(LeafEvent.self))
                    expect(unserialised.rule.ruleID).to(equal("id1"))
                    expect(unserialised.alreadyTriggered).to(beFalse())
                    expect(unserialised.currentCount).to(equal(2))
                    expect(unserialised.occurrences).to(equal(5))

                    expect(unserialised.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(unserialised.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(unserialised.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())
                }
                it("should trigger only after the correct number of repetition") {
                    let rep = RepetitionDecorator(occurrences: 5, rule: self.leafEvent1)
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.triggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beTrue())
                }
            }

            context("When Decorator is custom triggered") {
                it("should reset correctly the rule") {
                    let rep = RepetitionDecorator(occurrences: 5, rule: self.leafEvent1)
                    expect(rep.rule.alreadyTriggered).to(beTrue())
                    expect(rep.customTriggersWith(event: self.event1, activeStatuses: self.activeStatuses)).to(beFalse())
                    expect(rep.rule.alreadyTriggered).to(beFalse())
                }
            }
        }
    }
}
