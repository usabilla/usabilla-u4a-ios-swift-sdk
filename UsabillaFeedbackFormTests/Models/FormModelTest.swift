//
//  FormModelTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 08/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class FormModelTest: QuickSpec {

    var formModel: FormModel!
    var formViewController: FormViewController!

    override func spec() {
        describe("FormModelTest") {

            beforeEach {
                let path = Bundle(for: FormModelTest.self).path(forResource: "test", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: (data as? Data)!)
                self.formModel = JSONFormParser.parseFormJson(jsonObj, appId: "a", screenshot: nil, themeConfig: UsabillaThemeConfigurator())
            }

            it("form model toFeedbackResult should be empty") {

                let feedbackResult = self.formModel.toFeedbackResult(latestPageIndex: self.formModel.pages.count - 1)
                expect(feedbackResult.rating).to(beNil())
                expect(feedbackResult.abandonedPageIndex).to(beNil())
                expect(feedbackResult.sent).to(beTrue())
            }

            it("form model toFeedbackResult should have rating") {
                let model = ((self.formModel.pages.first?.fields.first {
                    type(of: $0) == RatingFieldModel.self || type(of: $0) == MoodFieldModel.self
                }) as? IntFieldModel)!
                model.fieldValue = 3
                let feedbackResult = self.formModel.toFeedbackResult(latestPageIndex: self.formModel.pages.count - 1)
                expect(feedbackResult.rating).to(equal(3))
                expect(feedbackResult.abandonedPageIndex).to(beNil())
                expect(feedbackResult.sent).to(beTrue())
            }

            it("form model toFeedbackResult should have rating and be abandoned") {
                let model = ((self.formModel.pages.first?.fields.first {
                    type(of: $0) == RatingFieldModel.self || type(of: $0) == MoodFieldModel.self
                    }) as? IntFieldModel)!
                model.fieldValue = 3
                let feedbackResult = self.formModel.toFeedbackResult(latestPageIndex: self.formModel.pages.count - 2)
                expect(feedbackResult.rating).to(equal(3))
                expect(feedbackResult.abandonedPageIndex).to(equal(self.formModel.pages.count - 2))
                expect(feedbackResult.sent).to(beFalse())
            }

            it("should have the correct redirectToAppStore value") {
                expect(self.formModel.redirectToAppStore).to(beFalse())
            }

            it("should have the correct redirectToAppStore value") {
                let path = Bundle(for: FormModelTest.self).path(forResource: "redirectEnabled", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: data! as Data)
                let formModel = JSONFormParser.parseFormJson(jsonObj, appId: "a", screenshot: nil, themeConfig: UsabillaThemeConfigurator())
                expect(formModel.redirectToAppStore).to(beTrue())
            }
        }
    }
}
