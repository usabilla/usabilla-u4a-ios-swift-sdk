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

class FormModelTests: QuickSpec {

    var formModel: FormModel!
    var jsonObj: JSON!
    var formViewController: FormViewController!

    override func spec() {
        describe("FormModelTest") {
            beforeEach {
                let path = Bundle(for: FormModelTests.self).path(forResource: "test", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                self.jsonObj = JSON(data: (data as Data?)!)
                self.formModel = FormModel(json: self.jsonObj, id: "a", screenshot: nil)
            }

            context("When initialized", {
                it("Should set all properties successfully", closure: {
                    expect(self.formModel).toNot(beNil())
                    expect(self.formModel.hasScreenshot).to(beTrue())
                    expect(self.formModel.version).to(equal(6))
                    expect(self.formModel.appId).to(equal("a"))
                    expect(self.formModel.pages.count).to(equal(4))
                    expect(self.formModel.pages[0].type).to(equal(PageType.form))
                    expect(self.formModel.pages[1].type).to(equal(PageType.form))
                    expect(self.formModel.pages[2].type).to(equal(PageType.form))
                    expect(self.formModel.pages[3].type).to(equal(PageType.end))
                    expect(self.formModel.isDefault).to(beFalse())
                    expect(self.formModel.formJsonString).to(equal(self.jsonObj))
                    expect(self.formModel.redirectToAppStore).to(beFalse())
                    expect(self.formModel.showProgressBar).to(beFalse())
                    expect(self.formModel.theme).toNot(beNil())
                    expect(self.formModel.copyModel).toNot(beNil())
                })
            })

            context("When calling toFeedbackResult", {
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
            })
        }
    }
}
