//
//  LeafActiveStatusTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 02/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class LeafActiveStatusTests: QuickSpec {
    
    let actviveStatus = ActiveStatus(name: "membership", value: "premium")
    var activeStatuses: [String: String] = [String: String]()
    
    override func spec() {
        describe("LeafActiveStatus") {
            
            context("When creating an object", {
                it("should initialise correctly") {
                    let leaf = LeafActiveStatus(activeStatus: ActiveStatus(name: "membership", value: "premium"))
                    expect(leaf.type).to(equal(RuleType.activeStatus))
                    expect(leaf.alreadyTriggered).to(beFalse())
                    expect(leaf.childRules).to(beEmpty())
                }
            })
            
            context("When initilized from JSON") {
                it("should fail if it does not have name") {
                    let leafJson = UBMock.json("LeafActiveStatus")?["WithoutName"]
                    let activeStatus = LeafActiveStatus(json: leafJson!)
                    expect(activeStatus).to(beNil())
                }
                it("should fail if it does not have value") {
                    let leafJson = UBMock.json("LeafActiveStatus")?["WithoutValue"]
                    let activeStatus = LeafActiveStatus(json: leafJson!)
                    expect(activeStatus).to(beNil())
                }
                it("should succeed if json is correct") {
                    let leafJson = UBMock.json("LeafActiveStatus")?["Correct"]
                    let leafActiveStatus = LeafActiveStatus(json: leafJson!)
                    expect(leafActiveStatus).toNot(beNil())
                    expect(leafActiveStatus?.type).to(equal(RuleType.activeStatus))
                    expect(leafActiveStatus?.activeStatus.name).to(equal("someName"))
                    expect(leafActiveStatus?.activeStatus.value).to(equal("someValue"))
                }
            }
            
            context("When checking for validity") {
                it("should trigger if the activeStatus matches") {
                    let leafActiveSattus = LeafActiveStatus(activeStatus: self.actviveStatus)
                    expect(leafActiveSattus.customTriggersWith(event: Event(name: ""), activeStatuses: ["membership": "premium"])).to(beTrue())
                    expect(leafActiveSattus.customTriggersWith(event: Event(name: ""), activeStatuses: ["SomeKey": "value", "membership": "premium", "blabla": "premium"])).to(beTrue())
                }
                it("should not trigger if the activeStatus does not match") {
                    let leafActiveSattus = LeafActiveStatus(activeStatus: self.actviveStatus)
                    expect(leafActiveSattus.customTriggersWith(event: Event(name: ""), activeStatuses: ["blabla": "premium"])).to(beFalse())
                    expect(leafActiveSattus.customTriggersWith(event: Event(name: ""), activeStatuses: ["membership": "anonymous"])).to(beFalse())
                    expect(leafActiveSattus.customTriggersWith(event: Event(name: ""), activeStatuses: ["bla": "membership", "membership": "anonymous", "blabla": "premium", "blablabla": "premiumA"])).to(beFalse())
                    expect(leafActiveSattus.customTriggersWith(event: Event(name: ""), activeStatuses: [String: String]())).to(beFalse())
                }
            }
        }
    }
}
