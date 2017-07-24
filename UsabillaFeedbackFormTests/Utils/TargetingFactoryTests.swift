//
//  TargetingFactoryTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 21/07/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

//swiftlint:disable force_cast

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class TargetingFactoryTests: QuickSpec {
    override func spec() {
        var targetingJson: JSON!

        beforeEach {
            targetingJson = UBMock.json("CampaignTargeting")?["options"]["rule"]
        }

        describe("TargetingFactory") {
            context("When parsing tageting json") {
                it("shoud return right components") {
                    let percentageDecorator = TargetingFactory.createRule(targetingJson) as! PercentageDecorator
                    expect(percentageDecorator).toNot(beNil())
                    expect(percentageDecorator.percentage).to(equal(77))

                    let repetitionDecorator = percentageDecorator.rule as! RepetitionDecorator

                    expect(repetitionDecorator.occurrences).to(equal(13))
                    expect(repetitionDecorator.rule is LeafRule).to(beTrue())

                    let leafRule = repetitionDecorator.rule as! LeafRule
                    expect(leafRule.event.name).to(equal("purchaseOrder"))
                }
                it("should return nil when the json is invalid") {
                    let json = JSON.parse("{\"hello\":\"you\"}")
                    let targeting = TargetingFactory.createRule(json)
                    expect(targeting).to(beNil())
                }

            }
        }
    }
}
