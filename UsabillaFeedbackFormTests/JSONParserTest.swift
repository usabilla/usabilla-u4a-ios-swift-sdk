//
//  JSONParserTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

// swiftlint:disable force_cast

class JSONParserTest: QuickSpec {

    override func spec() {

        var formModel: FormModel!
        var jsonObj: JSON!

        beforeSuite {
            let path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
            do {
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                jsonObj = JSON(data: data as Data)
                formModel = FormModel(json: jsonObj, id: "a", themeConfig: UsabillaThemeConfigurator(), screenshot: nil)

            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }

        }

        describe("the JSON parser") {
            context("with a valid form") {
                beforeEach {
                    //Only for this describe
                }

                it("should correctly extract the form settings") {
                    expect(formModel.copyModel.appTitle).to(equal("FeedbackTest"))
                    expect(formModel.copyModel.navigationSubmit).to(equal("TestSubmit"))
                    expect(formModel.hasScreenshot).to(equal(true))
                    expect(formModel.version).to(equal(6))
                    expect(formModel.appId).to(equal("a"))
                    expect(formModel.isDefault).to(equal(false))
                    expect(formModel.copyModel.errorMessage).to(equal("Error"))
                }

                describe("the colors group") {
                    it("should have been correctly parsed") {
                        expect(formModel.themeConfig.titleColor.hexString(false)).to(equal("#41474C"))
                        expect(formModel.themeConfig.accentColor.hexString(false)).to(equal("#00A5C9"))
                        expect(formModel.themeConfig.textColor.hexString(false)).to(equal("#59636B"))
                        expect(formModel.themeConfig.errorColor.hexString(false)).to(equal("#F4606E"))
                        expect(formModel.themeConfig.backgroundColor.hexString(false)).to(equal("#FFFFFF"))
                        expect(formModel.themeConfig.textOnAccentColor.hexString(false)).to(equal("#FFFFFF"))
                    }
                }
                describe("the pages array") {

                    it("should have been correctly parsed") {
                        let pages = formModel.pages
                        expect(pages.count).to(equal(4))
                    }

                    describe("the second page") {

                        it("should contain valid data") {
                            let page = formModel.pages[1]
                            expect(page.pageName).to(equal("second"))
                        }

                        it("should have the correct jump rule") {
                            let page = formModel.pages[0]
                            expect(page.defaultJumpTo).to(equal("Third"))
                            expect(page.jumpRuleList?.count).to(equal(1))
                            expect(page.jumpRuleList![0].jumpTo).to(equal("second"))
                            expect(page.jumpRuleList![0].dependsOnID).to(equal("nps"))
                            expect(page.jumpRuleList![0].targetValues.count).to(equal(5))
                            expect(page.jumpRuleList![0].targetValues).to(equal(["0", "1", "2", "3", "4"]))

                        }

                        describe("the field array") {

                            it("should have the correct properties") {
                                let fields = formModel.pages[0].fields
                                expect(fields.count).to(equal(6))
                            }

                            it("should containt a valid first field") {
                                let field: MoodFieldModel = (formModel.pages[0].fields[0]) as! MoodFieldModel
                                expect(field.fieldId).to(equal("mood"))
                                expect(field.fieldTitle).to(equal("Click to edit question"))
                                expect(field.type).to(equal("mood"))
                                expect(field.required).to(beTrue())
                                expect(field.fieldId).to(equal("mood"))
                                expect(field.fieldId).to(equal("mood"))
                                expect(field.rule).to(beNil())
                            }

                            it("should containt a valid second field") {
                                let field: ParagraphFieldModel = formModel.pages[0].fields[1] as! ParagraphFieldModel
                                expect(field.fieldTitle).to(beEmpty())
                                expect(field.fieldId).to(beEmpty())
                                expect(field.type).to(equal("paragraph"))
                                expect(field.required).to(beFalse())
                                expect(field.fieldValue).to(equal("I am a paragraph"))
                                expect(field.shouldAppear()).to(beFalse())
                                expect(field.rule?.showIfRuleIsSatisfied).to(beTrue())
                                expect(field.rule?.targetValues).to(equal(["1", "2"]))
                                expect(field.rule?.dependsOnID).to(equal("mood"))
                            }

                            it("should containt a valid third field") {
                                let field: RatingFieldModel = formModel.pages[0].fields[2] as! RatingFieldModel
                                expect(field.fieldTitle).to(equal("How likely are you to recommend our company/product/service to your friends and colleagues?"))
                                expect(field.fieldId).to(equal("nps"))
                                expect(field.type).to(equal("rating"))
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

                            it("should containt a valid fourth field") {
                                let field: TextFieldModel = formModel.pages[0].fields[3] as! TextFieldModel
                                expect(field.fieldTitle).to(equal("Click to edit"))
                                expect(field.fieldId).to(equal("text"))
                                expect(field.type).to(equal("text"))
                                expect(field.required).to(beFalse())
                                expect(field.fieldValue).to(beNil())
                                expect(field.placeHolder).to(equal("I am a placeholder"))
                                expect(field.shouldAppear()).to(beTrue())
                            }

                            it("should containt a valid fifth field") {
                                let field: CheckboxFieldModel = formModel.pages[0].fields[4] as! CheckboxFieldModel
                                expect(field.fieldTitle).to(equal("Checkboxah"))
                                expect(field.fieldId).to(equal("Checkboxah"))
                                expect(field.type).to(equal("checkbox"))
                                expect(field.required).to(beFalse())
                                expect(field.fieldValue).to(equal([]))
                                expect(field.shouldAppear()).to(beTrue())
                            }

                        }
                    }
                }

                describe("the page model") {

                    it("should have the correct jump rule") {
                        let pageModel = formModel.pages[0]
                        expect(pageModel.defaultJumpTo).to(equal("Third"))
                        expect(pageModel.jumpRuleList?.count).to(equal(1))
                        expect(pageModel.jumpRuleList?[0].jumpTo).to(equal("second"))
                        expect(pageModel.jumpRuleList?[0].dependsOnID).to(equal("nps"))
                        expect(pageModel.jumpRuleList?[0].targetValues).to(equal(["0", "1", "2", "3", "4"]))
                    }
                }
            }
        }
    }
}
