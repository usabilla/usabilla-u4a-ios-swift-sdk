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

    override func spec() {

        describe("EventEngineTests") {
            context("When instantiating eventengine") {
                it("should set the correct attributes") {
                    var eventEngine = EventEngine(campaigns: [])
                    expect(eventEngine.campaigns).to(beEmpty())

                    let campaigns = [
                        CampaignModel(id: "a", json: JSON.parse("")),
                        CampaignModel(id: "b", json: JSON.parse(""))
                    ]
                    eventEngine = EventEngine(campaigns: campaigns)
                    expect(eventEngine.campaigns.count).to(equal(2))
                }
            }
            context("When triggering an event") {
                it("should return no responding campaigns when they don't have event") {
                    let campaigns = [
                        CampaignModel(id: "a", json: JSON.parse("")),
                        CampaignModel(id: "b", json: JSON.parse(""))
                    ]
                    let eventEngine = EventEngine(campaigns: campaigns)
                    let (respondCampaigns, _) = eventEngine.triggerEvent("foo")
                    expect(respondCampaigns).to(beEmpty())
                }

                it("should return no responding campaigns when they don't match the event") {
                    let leaf = LeafRule(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf])

                    let campaigns = [
                        CampaignModel(id: "a", rule: rule, formId: "", maximumDisplays: 0, version: 0),
                        CampaignModel(id: "b", json: JSON.parse(""))
                    ]

                    let eventEngine = EventEngine(campaigns: campaigns)
                    let (respondCampaigns, _) = eventEngine.triggerEvent("foo")
                    expect(respondCampaigns).to(beEmpty())
                }

                it("should return the responding campaigns when they match the event") {
                    let leaf = LeafRule(event: Event(name: "foo"))
                    let rule = AndRule(childRules: [leaf])

                    let campaigns = [
                        CampaignModel(id: "a", rule: rule, formId: "", maximumDisplays: 0, version: 0),
                        CampaignModel(id: "b", json: JSON.parse(""))
                    ]

                    let eventEngine = EventEngine(campaigns: campaigns)
                    let (respondCampaigns, _) = eventEngine.triggerEvent("foo")
                    expect(respondCampaigns.count).to(equal(1))
                }

                it("should return the triggered campaigns") {
                    let leaf = LeafRule(event: Event(name: "foo"))
                    let leaf2 = LeafRule(event: Event(name: "bar"))
                    let rule = AndRule(childRules: [leaf, leaf2])

                    let campaigns = [
                        CampaignModel(id: "a", rule: rule, formId: "", maximumDisplays: 0, version: 0),
                        CampaignModel(id: "b", json: JSON.parse(""))
                    ]

                    let eventEngine = EventEngine(campaigns: campaigns)
                    var (respondCampaigns, triggeredCampaigns) = eventEngine.triggerEvent("foo")
                    expect(respondCampaigns.count).to(equal(1))
                    expect(triggeredCampaigns.count).to(equal(0))

                    (respondCampaigns, triggeredCampaigns) = eventEngine.triggerEvent("bar")
                    expect(respondCampaigns.count).to(equal(1))
                    expect(triggeredCampaigns.count).to(equal(1))
                }
            }
        }
    }
}
