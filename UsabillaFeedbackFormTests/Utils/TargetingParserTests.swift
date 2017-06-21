//
//  TargetingParserTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 21/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable force_cast

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class TargetingParserTests: QuickSpec {
    override func spec() {
        var targetingJson: JSON!
        beforeEach {
            let path = Bundle(for: TargetingParserTests.self).path(forResource: "CampaignTargeting", ofType: "json")!
            let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            targetingJson = JSON(data: (data as Data?)!)["options"]
        }
        describe("CampaignService") {

            context("When parsing a targeting") {
                it("should succeed if the json has the right format") {
                    let targeting = TargetingParser.targeting(fromJson: targetingJson)
                    expect(targeting).toNot(beNil())
                    expect(targeting is PercentageDecorator).to(beTrue())

                    let percentageDecorator = targeting as! PercentageDecorator

                    expect(percentageDecorator.percentage).to(equal(77))
                    expect(percentageDecorator.rule is RepetitionDecorator).to(beTrue())

                    let repetitionDecorator = percentageDecorator.rule as! RepetitionDecorator

                    expect(repetitionDecorator.occurrences).to(equal(13))
                    expect(repetitionDecorator.rule is LeafRule).to(beTrue())

                    let leafRule = repetitionDecorator.rule as! LeafRule

                    expect(leafRule.event.name).to(equal("purchaseOrder"))
                }

                it("should return nil when the json is invalid") {
                    let json = JSON.parse("{\"hello\":\"you\"}")
                    let targeting = TargetingParser.targeting(fromJson: json)
                    expect(targeting).to(beNil())
                }
            }
        }
    }
}
