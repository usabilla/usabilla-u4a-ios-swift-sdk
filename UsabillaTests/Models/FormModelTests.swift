//
//  FormModelTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 08/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

class FormModelTests: QuickSpec {

    var formModel: FormModel!
    var jsonObj: JSON!
    var formViewController: FormViewController!

    override func spec() {
        describe("FormModelTest") {
            beforeEach {
                self.formModel = UBMock.formMock()
            }

            context("When initialized") {
                it("Should set all properties successfully") {
                    expect(self.formModel).toNot(beNil())
                    expect(self.formModel.hasScreenshot).to(beTrue())
                    expect(self.formModel.version).to(equal(6))
                    expect(self.formModel.identifier).to(equal("mockFormId"))
                    expect(self.formModel.pages.count).to(equal(4))
                    expect(self.formModel.pages[0].type).to(equal(PageType.banner))
                    expect(self.formModel.pages[1].type).to(equal(PageType.form))
                    expect(self.formModel.pages[2].type).to(equal(PageType.form))
                    expect(self.formModel.pages[3].type).to(equal(PageType.end))
                    expect(self.formModel.formJsonString).toNot(beNil())
                    expect(self.formModel.showProgressBar).to(beFalse())
                    expect(self.formModel.theme).toNot(beNil())
                    expect(self.formModel.copyModel).toNot(beNil())
                }
                it("Should set all properties successfully when it is a campaign form model") {
                    self.jsonObj = UBMock.json(fromFile: "CampaignForm")
                    self.formModel = FormModel(json: self.jsonObj, id: "a", screenshot: nil)

                    expect(self.formModel).toNot(beNil())
                    expect(self.formModel.hasScreenshot).to(beFalse())
                    expect(self.formModel.version).to(equal(3))
                    expect(self.formModel.identifier).to(equal("a"))
                    expect(self.formModel.pages.count).to(equal(2))
                    expect(self.formModel.pages[0].type).to(equal(PageType.banner))
                    expect(self.formModel.pages[1].type).to(equal(PageType.toast))
                    expect(self.formModel.formJsonString).to(equal(self.jsonObj))
                    expect(self.formModel.theme).toNot(beNil())
                    expect(self.formModel.copyModel).toNot(beNil())
                }
                it("Should fail when form json does not contain \"form\" key") {
                    let json = UBMock.json("InvalidFormJsonNoForm")
                    let form = FormModel(json: json!, id: "id", screenshot: nil)

                    expect(form).to(beNil())
                }
                it("Should fail when form json does not contain \"pages\" key") {
                    let json = UBMock.json("InvalidFormJsonNoPages")
                    let form = FormModel(json: json!, id: "id", screenshot: nil)
                    
                    expect(form).to(beNil())
                }
            }

            context("When calling update theme") {
                it("should get the right theme from json with Structure") {
                    let json = UBMock.json("FormWithStructure")
                    let formModel = FormModel(json: json!, id: "id", screenshot: nil)
                    let previousTheme = formModel!.theme
                    expect(previousTheme).toNot(beNil())
                    formModel!.updateTheme()
                    expect(formModel!.theme).toNot(beNil())
                    expect(formModel!.theme.colors.background).toNot(equal(previousTheme.colors.background))
                }
                it("should get the right theme from json without Structure") {
                    let json = UBMock.json("FormWithoutStructure")
                    let formModel = FormModel(json: json!, id: "id", screenshot: nil)
                    let previousTheme = formModel!.theme
                    expect(previousTheme).toNot(beNil())
                    formModel!.updateTheme()
                    expect(formModel!.theme).toNot(beNil())
                    expect(formModel!.theme.colors.background).toNot(equal(previousTheme.colors.background))
                }
            }

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

            context("when exporting to json") {
                it ("should return export all the pages to json") {
                    let model = UBMock.formMock()
                    expect(model.pages.count).to(equal(4))

                    let dictionary = model.toDictionary()

                    expect(dictionary.keys.count).to(equal(6))
                    expect(dictionary.keys.contains("mood")).to(beTrue())
                    expect(dictionary.keys.contains("rating")).to(beTrue())
                    expect(dictionary.keys.contains("rating1")).to(beTrue())
                    expect(dictionary.keys.contains("text")).to(beTrue())
                    expect(dictionary.keys.contains("nps")).to(beTrue())
                    expect(dictionary.keys.contains("Checkboxah")).to(beTrue())
                }
            }
        }
    }
}
