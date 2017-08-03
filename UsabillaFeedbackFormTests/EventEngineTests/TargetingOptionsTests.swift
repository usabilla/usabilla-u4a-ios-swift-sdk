//
//  TargetingOptionsTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 02/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation


import Quick
import Nimble

@testable import UsabillaFeedbackForm

class TargetingOptionsTests: QuickSpec {
    override func spec() {

        var rule: Rule!

        describe("TargetingOptions") {
            context("When targeting has activeStatuses") {
                beforeEach {
                    let jsonActiveStatus = UBMock.json("TargetingActiveStatus")?["rule"]
                    rule = TargetingFactory.createRule(jsonActiveStatus!)
                }

                it("should trigger") {
                    let triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beTrue())
                }
                it("should not trigger when event is wrong") {
                    let triggered = rule.customTriggersWith(event: Event(name: "wrongEvent"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beFalse())
                }
                it("should not trigger when event and activeStatus are wrong") {
                    let triggered = rule.customTriggersWith(event: Event(name: "wrongEvent"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                }
                it("should not trigger when activeStatus is wrong") {
                    let triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                }
                it("should not trigger when activeStatus is wrong") {
                    var triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beTrue())
                }
                it("should trigger when second event is not matching") {
                    var triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "wrongEvent"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beTrue())
                }
            }

            context("When targeting has activeStatuses") {
                beforeEach {
                    let jsonActiveStatus = UBMock.json("TargetingActiveStatusMultipleRepetition")?["rule"]
                    rule = TargetingFactory.createRule(jsonActiveStatus!)
                }

                it("should trigger only after three times") {
                    var triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beTrue())
                }
                it("should not trigger when third event contains worng activeStatus") {
                    var triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                }
                it("should only trigger when event is sent with right activeStatus ") {
                    var triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["wrongKey": "premium"])
                    expect(triggered).to(beFalse())
                    triggered = rule.customTriggersWith(event: Event(name: "purchaseOrder"), activeStatuses: ["membership": "premium"])
                    expect(triggered).to(beTrue())
                }
            }
        }
    }
}
