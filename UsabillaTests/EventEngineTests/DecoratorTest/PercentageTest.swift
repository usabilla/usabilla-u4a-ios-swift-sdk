//
//  PercentageTest.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 30/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class PercentageDecoratorTests: QuickSpec {

    let event1 = Event(name: "event1")
    var leafEvent1: Rule!

    override func spec() {

        beforeEach {
            self.leafEvent1 = LeafEvent(event: self.event1, ruleID: "id1", alreadyTriggered: true)
        }

        describe("The percentage Decorator") {

            context("When creating an object", {
                it("should initialise correctly") {
                    let decorator = PercentageDecorator(percentage: 50, rule: self.leafEvent1)
                    expect(decorator.type).to(equal(RuleType.event))
                    expect(decorator.ruleID).to(equal("id1"))
                    expect(decorator.rule).to(be(self.leafEvent1))
                    expect(decorator.percentage).to(equal(50))
                    expect(decorator.diceAlreadyRolled).to(beFalse())
                }
            })

            context("When initilized from JSON") {
                it("should fail if it does not have any childern") {
                    let percentageJsonNoChilderen = UBMock.json("PercentageDecoratorNoChilderen")?["rule"]
                    let decorator = PercentageDecorator(json: percentageJsonNoChilderen!)
                    expect(decorator).to(beNil())
                }
                it("should fail if it does not have percentage") {
                    let percentageJsonNoChilderen = UBMock.json("PercentageDecoratorNoPercentage")?["rule"]
                    let decorator = PercentageDecorator(json: percentageJsonNoChilderen!)
                    expect(decorator).to(beNil())
                }
                it("should succeed if json is correct") {
                    let percentageJsonNoChilderen = UBMock.json("CampaignsTargetingWithCustomVariable")?["rule"]
                    let decorator = PercentageDecorator(json: percentageJsonNoChilderen!)
                    expect(decorator).toNot(beNil())
                    expect(decorator?.type).to(equal(RuleType.event))
                    expect(decorator?.percentage).to(equal(20))
                    expect(decorator?.diceAlreadyRolled).to(beFalse())
                }
            }

            context("When throwing a dice", {
                it("should not trigger if the dice is bigger than the chance") {
                    let decorator = PercentageDecorator(percentage: 50, rule: self.leafEvent1)
                    expect(decorator.checkIfTriggers(triggered: true, diceRoll: 51)).to(beFalse())
                }
                it("should trigger if the dice is equal to the chance") {
                    let decorator = PercentageDecorator(percentage: 50, rule: self.leafEvent1)
                    expect(decorator.checkIfTriggers(triggered: true, diceRoll: 50)).to(beTrue())
                }
                it("should trigger if the dice is lower than the chance") {
                    let decorator = PercentageDecorator(percentage: 50, rule: self.leafEvent1)
                    expect(decorator.checkIfTriggers(triggered: true, diceRoll: 49)).to(beTrue())
                }
            })

            context("When the rule is satisfied and the dice is rolled") {
                it("should trigger only the first time") {
                    let decorator = PercentageDecorator(percentage: 50, rule: self.leafEvent1)
                    expect(decorator.checkIfTriggers(triggered: true, diceRoll: 10)).to(beTrue())
                    expect(decorator.checkIfTriggers(triggered: true, diceRoll: 10)).to(beFalse())
                }
            }

            context("When the rule is not satisfied", {
                it("should not trigger if the rule is not satisfied") {
                    let decorator = PercentageDecorator(percentage: 50, rule: self.leafEvent1)
                    expect(decorator.checkIfTriggers(triggered: false, diceRoll: 51)).to(beFalse())
                }
                it("should not trigger if the rule is not satisfied") {
                    let decorator = PercentageDecorator(percentage: 50, rule: self.leafEvent1)
                    expect(decorator.checkIfTriggers(triggered: false, diceRoll: 50)).to(beFalse())
                }
                it("should not trigger if the rule is not satisfied") {
                    let decorator = PercentageDecorator(percentage: 50, rule: self.leafEvent1)
                    expect(decorator.checkIfTriggers(triggered: false, diceRoll: 49)).to(beFalse())
                }
            })

            context("When initializing via NSCoder") {
                it("should serialize and deserialize correctly") {
                    let decorator = PercentageDecorator(percentage: 50, rule: self.leafEvent1)
                    decorator.diceAlreadyRolled = true
                    let data = NSKeyedArchiver.archivedData(withRootObject: decorator)
                    expect(data).toNot(beNil())

                    // swiftlint:disable force_cast
                    let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! PercentageDecorator
                    expect(unserialised.percentage).to(equal(50))
                    expect(unserialised.diceAlreadyRolled).to(beTrue())
                }
            }
        }
    }
}
