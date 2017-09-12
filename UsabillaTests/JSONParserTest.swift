//
//  JSONParserTest.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 20/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

// swiftlint:disable force_cast
// swiftlint:disable force_try

class JSONParserTest: QuickSpec {

    override func spec() {

        var formModel: FormModel!
        var jsonObj: JSON!
        var oneButtonCampaign: JSON!
        var paragraphCampaign: JSON!

        beforeSuite {
            // read test.json
            var path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
            var data = try! NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            jsonObj = JSON(data: data as Data)
            formModel = FormModel(json: jsonObj, id: "a", screenshot: nil)

            // read OneButtonCampaign.json
            path = Bundle(for: JSONParserTest.self).path(forResource: "OneButtonCampaign", ofType: "json")!
            data = try! NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            oneButtonCampaign = JSON(data: data as Data)

            // read CampaignBannerParagraph.json
            paragraphCampaign = UBMock.json("CampaignBannerParagraph")
        }

        describe("JSONFormParser") {

            it("returns the correct structure holder") {
                expect(JSONFormParser.getStructureHolder(inJSON: oneButtonCampaign)).to(equal(oneButtonCampaign["structure"]))
                expect(JSONFormParser.getStructureHolder(inJSON: jsonObj)).to(equal(jsonObj))
            }

            context("When initilized with a valid Json") {
                it("should correctly extract the form settings") {
                    expect(formModel.copyModel.appTitle).to(equal("FeedbackTest"))
                    expect(formModel.copyModel.navigationSubmit).to(equal("TestSubmit"))
                    expect(formModel.hasScreenshot).to(equal(true))
                    expect(formModel.version).to(equal(6))
                    expect(formModel.identifier).to(equal("a"))
                    expect(formModel.copyModel.errorMessage).to(equal("Error"))
                }
                it("checks for the continue button correctly") {
                    expect(JSONFormParser.checkForContinueButton(pageJson: oneButtonCampaign["structure"]["form"]["pages"][0])).to(beFalse())
                    expect(JSONFormParser.checkForContinueButton(pageJson: oneButtonCampaign["structure"]["form"]["pages"][1])).to(beTrue())
                }
                it("should correctly extract the colors") {
                    expect(formModel.theme.colors.title.hexString(false)).to(equal("#41474C"))
                    expect(formModel.theme.colors.accent.hexString(false)).to(equal("#00A5C9"))
                    expect(formModel.theme.colors.text.hexString(false)).to(equal("#59636B"))
                    expect(formModel.theme.colors.error.hexString(false)).to(equal("#F4606E"))
                    expect(formModel.theme.colors.background.hexString(false)).to(equal("#FFFFFF"))
                    expect(formModel.theme.colors.textOnAccent.hexString(false)).to(equal("#FFFFFF"))
                }
                it("should correctly parse the pages") {
                    let pages = formModel.pages
                    expect(pages.count).to(equal(4))
                    expect(pages[0].pageName).to(equal("start"))
                    expect(pages[1].pageName).to(equal("second"))
                    expect(pages[2].pageName).to(equal("Third"))
                    expect(pages[3].pageName).to(equal("end"))
                }
            }

            context("when pages are parsed") {
                it("should extract the correct jump rules for first page") {
                    let page = formModel.pages[0]
                    expect(page.defaultJumpTo).to(equal("Third"))
                    expect(page.jumpRuleList?.count).to(equal(1))
                    expect(page.jumpRuleList![0].jumpTo).to(equal("second"))
                    expect(page.jumpRuleList![0].dependsOnID).to(equal("nps"))
                    expect(page.jumpRuleList![0].targetValues.count).to(equal(5))
                    expect(page.jumpRuleList![0].targetValues).to(equal(["0", "1", "2", "3", "4"]))
                }
                it("should extract fields correctly for first page") {
                    let fields = formModel.pages[0].fields
                    expect(fields.count).to(equal(6))
                }
            }

            context("when fields are parsed") {
                it("should set correct values for field 1") {
                    let field: MoodFieldModel = (formModel.pages[0].fields[0]) as! MoodFieldModel
                    expect(field.fieldID).to(equal("mood"))
                    expect(field.fieldTitle).to(equal("Click to edit question"))
                    expect(field.type).to(equal("mood"))
                    expect(field.required).to(beTrue())
                    expect(field.fieldID).to(equal("mood"))
                    expect(field.fieldID).to(equal("mood"))
                    expect(field.rule).to(beNil())
                }
                it("should set correct values for field 2") {
                    let field: ParagraphFieldModel = formModel.pages[0].fields[1] as! ParagraphFieldModel
                    expect(field.fieldTitle).to(beEmpty())
                    expect(field.fieldID).to(beEmpty())
                    expect(field.type).to(equal("paragraph"))
                    expect(field.required).to(beFalse())
                    expect(field.fieldValue).to(equal("I am a paragraph"))
                    expect(field.shouldAppear()).to(beFalse())
                    expect(field.rule?.showIfRuleIsSatisfied).to(beTrue())
                    expect(field.rule?.targetValues).to(equal(["1", "2"]))
                    expect(field.rule?.dependsOnID).to(equal("mood"))
                }
                it("should set correct values for field 3") {
                    let field: NPSFieldModel = formModel.pages[0].fields[2] as! NPSFieldModel
                    expect(field.fieldTitle).to(equal("How likely are you to recommend our company/product/service to your friends and colleagues?"))
                    expect(field.fieldID).to(equal("nps"))
                    expect(field.type).to(equal("nps"))
                    expect(field.required).to(beTrue())
                    expect(field.fieldValue).to(beNil())
                    expect(field.shouldAppear()).to(beFalse())
                    expect(field.rule?.showIfRuleIsSatisfied).to(beTrue())
                    expect(field.rule?.targetValues).to(equal(["4", "5"]))
                    expect(field.rule?.dependsOnID).to(equal("mood"))
                    expect(field.high).to(equal("very likely"))
                    expect(field.low).to(equal("not at all"))
                    expect(field.shouldAppear()).to(beFalse())
                }
                it("should set correct values for field 4") {
                    let field: TextFieldModel = formModel.pages[0].fields[3] as! TextFieldModel
                    expect(field.fieldTitle).to(equal("Click to edit"))
                    expect(field.fieldID).to(equal("text"))
                    expect(field.type).to(equal("text"))
                    expect(field.required).to(beFalse())
                    expect(field.fieldValue).to(beNil())
                    expect(field.placeHolder).to(equal("I am a placeholder"))
                    expect(field.shouldAppear()).to(beTrue())
                }
                it("should set correct values for field 5") {
                    let field: CheckboxFieldModel = formModel.pages[0].fields[4] as! CheckboxFieldModel
                    expect(field.fieldTitle).to(equal("Checkboxah"))
                    expect(field.fieldID).to(equal("Checkboxah"))
                    expect(field.type).to(equal("checkbox"))
                    expect(field.required).to(beFalse())
                    expect(field.fieldValue).to(equal([]))
                    expect(field.shouldAppear()).to(beTrue())
                }
            }

            context("When parsePage is called") {
                it("should parse correctly page properties") {
                    let firstPage = oneButtonCampaign["structure"]["form"]["pages"].array?.first
                    let firstPageModel = JSONFormParser.parsePage(firstPage!, pageNum: 0)
                    expect(firstPageModel.pageName).to(equal("Banner"))
                    expect(firstPageModel.type).to(equal(PageType.banner))
                    expect(firstPageModel.fields.count).to(equal(1))
                }
                it("should parse correctly the paragraph") {
                    let firstPage = paragraphCampaign["structure"]["form"]["pages"].array?.first
                    let firstPageModel = JSONFormParser.parsePage(firstPage!, pageNum: 0)
                    let firstField = firstPageModel.fields.first
                    expect(firstField is ParagraphFieldModel).to(beTrue())
                    expect(firstField?.fieldTitle).toNot(beNil())
                }
                it("should parse correctly the paragraph") {
                    let firstPage = paragraphCampaign["structure"]["form"]["pages"].array?.first
                    let firstPageModel = JSONFormParser.parsePage(firstPage!, pageNum: 0)
                    let firstField = firstPageModel.fields.first
                    expect(firstField is ParagraphFieldModel).to(beTrue())
                    expect(firstField?.fieldTitle).toNot(beNil())
                }
                it("should parse correctly the mood model") {
                    let firstPage = oneButtonCampaign["structure"]["form"]["pages"].array?.first
                    let firstPageModel = JSONFormParser.parsePage(firstPage!, pageNum: 0)
                    let firstField = firstPageModel.fields.first
                    expect(firstField is MoodFieldModel).to(beTrue())
                    expect(firstField?.fieldTitle).toNot(beNil())
                }
            }
        }
    }
}
