//
//  LeafPassiveStatusTests.swift
//  Usabilla
//
//  Created by Adil Bougamza on 08/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Usabilla

class LeafPassiveStatusTests: QuickSpec {
    let passiveStatus = PassiveStatus(name: PassiveStatus.PasstiveStatusType.language, value: "en")
    var activeStatuses: [String: String] = ["membership": "premium"]
    
    override func spec() {
        describe("LeafPassiveStatus") {
            
            context("When creating an object", {
                it("should initialise correctly") {
                    let leaf = LeafPassiveStatus(passiveStatus: self.passiveStatus)
                    expect(leaf.type).to(equal(RuleType.passiveStatus))
                    expect(leaf.alreadyTriggered).to(beFalse())
                    expect(leaf.childRules).to(beEmpty())
                }
                it("should serialize correctly") {
                    let leafPassiveStatus = LeafPassiveStatus(passiveStatus: self.passiveStatus)
                    let data = NSKeyedArchiver.archivedData(withRootObject: leafPassiveStatus)
                    
                    expect(data).toNot(beNil())
                    // swiftlint:disable force_cast
                    let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! LeafPassiveStatus
                    expect(unserialised.passiveStatus).toNot(beNil())
                    expect(unserialised.passiveStatus.name).to(equal(PassiveStatus.PasstiveStatusType.language))
                    expect(unserialised.passiveStatus.value).to(equal("en"))
                }
            })
            
            context("When initilized from JSON") {
                it("should fail if it does not have name") {
                    let leafJson = UBMock.json("LeafPassiveStatus")?["WithoutName"]
                    let leafPassiveStatus = LeafPassiveStatus(json: leafJson!)
                    expect(leafPassiveStatus).to(beNil())
                }
                it("should fail if name is not in part of PassiveStatusType") {
                    let leafJson = UBMock.json("LeafPassiveStatus")?["WithWrongName"]
                    let leafPassiveStatus = LeafPassiveStatus(json: leafJson!)
                    expect(leafPassiveStatus).to(beNil())
                }
                it("should fail if it does not have value") {
                    let leafJson = UBMock.json("LeafPassiveStatus")?["WithoutValue"]
                    let leafPassiveStatus = LeafPassiveStatus(json: leafJson!)
                    expect(leafPassiveStatus).to(beNil())
                }
                it("should succeed if json is correct") {
                    let leafJson = UBMock.json("LeafPassiveStatus")?["Correct"]
                    let leafPassiveStatus = LeafPassiveStatus(json: leafJson!)
                    expect(leafPassiveStatus).toNot(beNil())
                    expect(leafPassiveStatus?.type).to(equal(RuleType.passiveStatus))
                    expect(leafPassiveStatus?.passiveStatus.name.rawValue).to(equal("language"))
                    expect(leafPassiveStatus?.passiveStatus.value).to(equal("nl"))
                }
            }
            
            context("When checking for validity") {
                it("should trigger if the passive status matches") {
                    let leafPassiveStatus = LeafPassiveStatus(passiveStatus: PassiveStatus(name: PassiveStatus.PasstiveStatusType.language, value: "en"))
                    expect(leafPassiveStatus.customTriggersWith(event: Event(name: ""), activeStatuses: self.activeStatuses)).to(beTrue())
                }
                it("should trigger if the passive status uppercased matches") {
                    let leafPassiveStatus = LeafPassiveStatus(passiveStatus: PassiveStatus(name: PassiveStatus.PasstiveStatusType.language, value: "EN"))
                    expect(leafPassiveStatus.customTriggersWith(event: Event(name: ""), activeStatuses: self.activeStatuses)).to(beTrue())
                }
                it("should trigger if the passive status has ISO-3 format : en_US") {
                    let leafPassiveStatus = LeafPassiveStatus(passiveStatus: PassiveStatus(name: PassiveStatus.PasstiveStatusType.language, value: "en_US"))
                    expect(leafPassiveStatus.customTriggersWith(event: Event(name: ""), activeStatuses: self.activeStatuses)).to(beTrue())
                }
                it("should not trigger if the passive status does not match the ISO-3") {
                    let leafPassiveStatus = LeafPassiveStatus(passiveStatus: PassiveStatus(name: PassiveStatus.PasstiveStatusType.language, value: "en_GB"))
                    expect(leafPassiveStatus.customTriggersWith(event: Event(name: ""), activeStatuses: self.activeStatuses)).to(beFalse())
                }
                it("should not trigger if the passive status does not match") {
                    let leafPassiveStatus = LeafPassiveStatus(passiveStatus: PassiveStatus(name: PassiveStatus.PasstiveStatusType.language, value: "nl"))
                    expect(leafPassiveStatus.customTriggersWith(event: Event(name: ""), activeStatuses: self.activeStatuses)).to(beFalse())
                }
            }
        }
    }
}
