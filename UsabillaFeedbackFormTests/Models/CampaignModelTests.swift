//
//  CampaignModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 27/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaignModelTests: QuickSpec {

    override func spec() {
        var formJson: JSON!

        beforeSuite {
            let path = Bundle(for: EmailFieldModelTest.self).path(forResource: "test", ofType: "json")!
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
                    let campaign = Campaign(id: "id", json: formJson)
                    expect(campaign.id).to(equal("id"))
                    expect(campaign.form.pages.count).to(equal(4))
                }
            }
        }
    }
}
