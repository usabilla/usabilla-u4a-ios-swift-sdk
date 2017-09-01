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
                    let campaignID = "campaignID"
                    let event = Event(name: "myEvent")
                    let rule = LeafEvent(event: event)
                    let formID = "formID"
                    let targetingID = "targetingID"
                    let maxDisplays = 0
                    let numberOfTimesTriggered = 0

                    let campaign = CampaignModel(id: campaignID, rule: rule, formID: formID, targetingID: targetingID, maximumDisplays: maxDisplays, numberOfTimesTriggered: numberOfTimesTriggered, status: .active, createdAt: Date())
                    let formModel = FormModel(json: formJson, id: "", screenshot: nil)
                    campaign.form = formModel

                    expect(campaign.identifier).to(equal(campaignID))
                    // swiftlint:disable force_cast
                    expect((campaign.rule as! LeafEvent).event).to(equal(event))
                    expect(campaign.formID).to(equal(formID))
                    expect(campaign.targetingID).to(equal(targetingID))
                    expect(campaign.maximumDisplays).to(equal(maxDisplays))
                    expect(campaign.numberOfTimesTriggered).to(equal(numberOfTimesTriggered))
                    expect(campaign.form?.pages.count).to(equal(4))
                }
            }

            context("When CampaignModel is archived") {
                it("Should have right values when unarchived") {
                    let campaignID = "campaignID"
                    let event = Event(name: "myEvent")
                    let rule = LeafEvent(event: event)
                    let formID = "formID"
                    let targetingID = "targetingID"
                    let maxDisplays = 0
                    let numberOfTimesTriggered = 0
                    let status = CampaignModel.Status.invalid

                    let campaign = CampaignModel(id: campaignID, rule: rule, formID: formID, targetingID: targetingID, maximumDisplays: maxDisplays, numberOfTimesTriggered: numberOfTimesTriggered, status: status, createdAt: Date())
                    let data = NSKeyedArchiver.archivedData(withRootObject: campaign)

                    expect(data).toNot(beNil())
                    // swiftlint:disable force_cast
                    let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! CampaignModel

                    expect(campaign.identifier).to(equal(campaignID))
                    // swiftlint:disable force_cast
                    expect((unserialised.rule as! LeafEvent).event.name).to(equal(event.name))
                    expect(unserialised.formID).to(equal(formID))
                    expect(unserialised.targetingID).to(equal(targetingID))
                    expect(unserialised.maximumDisplays).to(equal(maxDisplays))
                    expect(unserialised.numberOfTimesTriggered).to(equal(numberOfTimesTriggered))
                    expect(unserialised.status).to(equal(CampaignModel.Status.invalid))
                }
            }

            context("When CampaignModel is initialized with json") {
                it("Should have right values") {
                    let campaignID = "campaignID"
                    let formID = "formID"
                    let targetingID = "targetingID"
                    let maxDisplays = 0
                    let numberOfTimesTriggered = 0

                    var json = "{\"id\": \"\(campaignID)\", \"form_id\": \"\(formID)\", \"targeting_options_id\": \"\(targetingID)\", \"maximumDisplays\": \(maxDisplays), \"status\": \"active\", \"created_at\": \"2017-07-17T13:25:33+00:00\"}"
                    var campaign = CampaignModel(json: JSON.parse(json))

                    expect(campaign).toNot(beNil())
                    expect(campaign!.identifier).to(equal(campaignID))
                    expect(campaign!.formID).to(equal(formID))
                    expect(campaign!.targetingID).to(equal(targetingID))
                    expect(campaign!.maximumDisplays).to(equal(maxDisplays))
                    expect(campaign!.numberOfTimesTriggered).to(equal(numberOfTimesTriggered))
                    expect(campaign!.status).to(equal(CampaignModel.Status.active))
                    expect(campaign!.createdAt.description).to(equal("2017-07-17 13:25:33 +0000"))
                    json = "{\"id\": \"\(campaignID)\", \"form_id\": \"\(formID)\", \"targeting_options_id\": \"\(targetingID)\", \"maximumDisplays\": \(maxDisplays), \"status\": \"inactive\", \"created_at\": \"2017-07-17T13:25:33+00:00\"}"
                    campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign!.status).to(equal(CampaignModel.Status.inactive))

                    json = "{\"id\": \"\(campaignID)\", \"form_id\": \"\(formID)\", \"targeting_options_id\": \"\(targetingID)\", \"maximumDisplays\": \(maxDisplays), \"status\": \"invalid\", \"created_at\": \"2017-07-17T13:25:33+00:00\"}"
                    campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign!.status).to(equal(CampaignModel.Status.invalid))
                }

                it("Should fail when id property is missing") {
                    let targetingID = "targetingID"
                    let formID = "formID"
                    let maxDisplays = 0
                    let status = "active"
                    let json = "{\"form_id\": \"\(formID)\", \"targeting_options_id\": \"\(targetingID)\", \"maximumDisplays\": \(maxDisplays), \"status\": \"\(status)\", \"created_at\": \"2017-07-17T13:25:33+00:00\"}}"

                    let campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign).to(beNil())
                }
                it("Should fail when formID property is missing") {
                    let campaignID = "campaignID"
                    let targetingID = "targetingID"
                    let maxDisplays = 0
                    let status = "active"
                    let json = "{\"id\": \"\(campaignID)\", \"targeting_options_id\": \"\(targetingID)\", \"maximumDisplays\": \(maxDisplays), \"status\": \"\(status)\", \"created_at\": \"2017-07-17T13:25:33+00:00\"}}"

                    let campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign).to(beNil())
                }
                it("Should fail when targetingID property is missing") {
                    let campaignID = "campaignID"
                    let formID = "formID"
                    let maxDisplays = 0
                    let status = "active"
                    let json = "{\"id\": \"\(campaignID)\",\"form_id\": \"\(formID)\", \"maximumDisplays\": \(maxDisplays), \"status\": \"\(status)\", \"created_at\": \"2017-07-17T13:25:33+00:00\"}}"

                    let campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign).to(beNil())
                }
                it("Should fail when status property is missing") {
                    let campaignID = "campaignID"
                    let formID = "formID"
                    let targetingID = "targetingID"
                    let maxDisplays = 0
                    let json = "{\"id\": \"\(campaignID)\", \"form_id\": \"\(formID)\", \"targeting_options_id\": \"\(targetingID)\", \"maximumDisplays\": \(maxDisplays), \"created_at\": \"2017-07-17T13:25:33+00:00\"}"

                    let campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign).to(beNil())
                }
                it("Should fail when createdAt property is missing") {
                    let campaignID = "campaignID"
                    let formID = "formID"
                    let targetingID = "targetingID"
                    let maxDisplays = 0
                    let json = "{\"id\": \"\(campaignID)\", \"form_id\": \"\(formID)\", \"targeting_options_id\": \"\(targetingID)\", \"maximumDisplays\": \(maxDisplays)}"
                    
                    let campaign = CampaignModel(json: JSON.parse(json))
                    expect(campaign).to(beNil())
                }
            }
        }
    }
}
