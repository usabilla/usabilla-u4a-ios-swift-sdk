//
//  CampaignModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 27/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length
import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaignModelTests: QuickSpec {

    override func spec() {
        var formJson: JSON!

        beforeSuite {
            let path = Bundle(for: CampaignModelTests.self).path(forResource: "test", ofType: "json")!
            do {
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                formJson = JSON(data: data as Data)
            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }
        }
        describe("CampaignModelTests") {
            context("When CampaignModel is initialized") {
                it("Should have right values") {
                    let campaignId = "campaignId"
                    let event = Event(name: "myEvent")
                    let rule = LeafRule(event: event)
                    let formId = "formId"
                    let targetingId = "targetingId"
                    let maxDisplays = 0
                    let numberOfTimesTriggered = 0

                    let campaign = CampaignModel(id: campaignId, rule: rule, formId: formId, targetingId: targetingId, maximumDisplays: maxDisplays, numberOfTimesTriggered: numberOfTimesTriggered)
                    let formModel = FormModel(json: formJson, id: "", screenshot: nil)
                    campaign.form = formModel

                    expect(campaign.identifier).to(equal(campaignId))
                    // swiftlint:disable force_cast
                    expect((campaign.rule as! LeafRule).event).to(equal(event))
                    expect(campaign.formId).to(equal(formId))
                    expect(campaign.targetingId).to(equal(targetingId))
                    expect(campaign.maximumDisplays).to(equal(maxDisplays))
                    expect(campaign.numberOfTimesTriggered).to(equal(numberOfTimesTriggered))
                    expect(campaign.form?.pages.count).to(equal(4))
                }
            }

            context("When CampaignModel is initialized with json") {
                it("Should have right values") {
                    let campaignId = "campaignId"
                    let formId = "formId"
                    let targetingId = "targetingId"
                    let maxDisplays = 0
                    let numberOfTimesTriggered = 0

                    let json = "{\"id\": \"\(campaignId)\", \"form_id\": \"\(formId)\", \"targeting_options_id\": \"\(targetingId)\", \"maximumDisplays\": \(maxDisplays)}"

                    let campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign).toNot(beNil())

                    expect(campaign!.identifier).to(equal(campaignId))
                    expect(campaign!.formId).to(equal(formId))
                    expect(campaign!.targetingId).to(equal(targetingId))
                    expect(campaign!.maximumDisplays).to(equal(maxDisplays))
                    expect(campaign!.numberOfTimesTriggered).to(equal(numberOfTimesTriggered))
                }
                it("Should fail when id property is missing") {
                    let targetingId = "targetingId"
                    let formId = "formId"
                    let maxDisplays = 0
                    let json = "{\"form_id\": \"\(formId)\", \"targeting_options_id\": \"\(targetingId)\", \"maximumDisplays\": \(maxDisplays)}"

                    let campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign).to(beNil())
                }
                it("Should fail when formId property is missing") {
                    let campaignId = "campaignId"
                    let targetingId = "targetingId"
                    let maxDisplays = 0
                    let json = "{\"id\": \"\(campaignId)\", \"targeting_options_id\": \"\(targetingId)\", \"maximumDisplays\": \(maxDisplays)}"

                    let campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign).to(beNil())
                }
                it("Should fail when targetingId property is missing") {
                    let campaignId = "campaignId"
                    let formId = "formId"
                    let maxDisplays = 0
                    let json = "{\"id\": \"\(campaignId)\",\"form_id\": \"\(formId)\", \"maximumDisplays\": \(maxDisplays)}"

                    let campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign).to(beNil())
                }
            }
        }
    }
}