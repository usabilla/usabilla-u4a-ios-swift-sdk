//
//  EventEngineTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class EventEngineTests: QuickSpec {
    
    func campaignMock(forId id: String) -> CampaignModel {
        return CampaignModel(id: id, rule: nil, formId: "", targetingId: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .active)
    }
    var campaigns: [CampaignModel] = []
    var activeStatuses: [String: String] = [String: String]()

    override func spec() {

        describe("EventEngineTests") {
            beforeEach {
                self.campaigns = [
                    self.campaignMock(forId: "a"),
                    self.campaignMock(forId: "b")
                ]
            }
            context("When instantiating eventengine") {
                it("should set the correct attributes") {
                    var eventEngine = EventEngine(campaigns: [])
                    expect(eventEngine.campaigns).to(beEmpty())
                    eventEngine = EventEngine(campaigns: self.campaigns)
                    expect(eventEngine.campaigns.count).to(equal(2))
                }
            }

            context("When triggering an event") {
                it("should return no responding campaigns when they don't have event") {
                    let eventEngine = EventEngine(campaigns: self.campaigns)
                    let (respondCampaigns, _) = eventEngine.sendEvent("foo", activeStatuses: self.activeStatuses)
                    expect(respondCampaigns).to(beEmpty())
                }

                it("should return no responding campaigns when they don't match the event") {
                    let leaf = LeafEvent(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf])
                    self.campaigns[0].rule = rule
                    let eventEngine = EventEngine(campaigns: self.campaigns)
                    let (respondCampaigns, _) = eventEngine.sendEvent("foo", activeStatuses: self.activeStatuses)
                    expect(respondCampaigns).to(beEmpty())
                }

                it("should return the responding campaigns when they match the event") {
                    let leaf = LeafEvent(event: Event(name: "foo"))
                    let rule = AndRule(childRules: [leaf])
                    self.campaigns[0].rule = rule
                    let eventEngine = EventEngine(campaigns: self.campaigns)
                    let (respondCampaigns, _) = eventEngine.sendEvent("foo", activeStatuses: self.activeStatuses)
                    expect(respondCampaigns.count).to(equal(1))
                }

                it("should return the triggered campaigns") {
                    let leaf = LeafEvent(event: Event(name: "foo"))
                    let leaf2 = LeafEvent(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf, leaf2])
                    self.campaigns[0].rule = rule
                    let eventEngine = EventEngine(campaigns: self.campaigns)
                    var (respondCampaigns, triggeredCampaigns) = eventEngine.sendEvent("foo", activeStatuses: self.activeStatuses)
                    expect(respondCampaigns.count).to(equal(1))
                    expect(triggeredCampaigns.count).to(equal(0))

                    (respondCampaigns, triggeredCampaigns) = eventEngine.sendEvent("bar", activeStatuses: self.activeStatuses)
                    expect(respondCampaigns.count).to(equal(1))
                    expect(triggeredCampaigns.count).to(equal(1))
                }
            }
        }
    }
}
