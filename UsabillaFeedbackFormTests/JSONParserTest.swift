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

class JSONParserTest: QuickSpec {
    
    override func spec() {
        
        var formModel: FormModel!
        
        beforeSuite {
            let path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
            do {
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data:data as Data)
                formModel = JSONFormParser.parseFormJson(jsonObj, appId: "a", screenshot: nil, themeConfig: UsabillaThemeConfigurator())
                
            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }
            
        }
        
        describe("the JSON parser") {
            context("with a valid form"){
                beforeEach {
                    //Only for this describe
                }
                
                it("should correctly extract the form settings"){
                    expect(formModel.copyModel.appTitle).to(equal("FeedbackTest"))
                    expect(formModel.copyModel.navigationSubmit).to(equal("TestSubmit"))
                    expect(formModel.hasScreenshot).to(equal(true))
                    expect(formModel.version).to(equal(1))
                    expect(formModel.appId).to(equal("a"))
                    expect(formModel.isDefault).to(equal(false))
                    expect(formModel.copyModel.errorMessage).to(equal("Error"))
                }
                
                describe("the pages array"){
                    
                    it("should have been correctly parsed"){
                        let pages = formModel.pages
                        expect(pages.count).to(equal(4))
                    }
                    
                    describe("the second page"){
                        
                        it("should contain valid data"){
                            let page = formModel.pages[1]
                            expect(page.pageName).to(equal("middle"))
                        }
                        
                        it("should have the correct jump rule"){
                            let page = formModel.pages[1]
                            expect(page.defaultJumpTo).to(equal("end"))
                            expect(page.jumpRuleList?.count).to(equal(1))
                            expect(page.jumpRuleList![0].jumpTo).to(equal("secondMiddle"))
                            expect(page.jumpRuleList![0].dependsOnID).to(equal("SISSM"))
                            expect(page.jumpRuleList![0].targetValues.count).to(equal(1))
                            expect(page.jumpRuleList![0].targetValues[0]).to(equal("option_1"))
                            
                        }
                        
                        describe("the field array"){
                            
                            it("should have the correct properties"){
                                let fields = formModel.pages[1].fields
                                expect(fields.count).to(equal(4))
                                
                            }
                            
                            it("should containt a valid first field"){
                                let field: CheckboxFieldModel = (formModel.pages[1].fields[0]) as! CheckboxFieldModel
                                expect(field.fieldId).to(equal("SISSM"))
                                expect(field.fieldTitle).to(equal("SISSM"))
                                expect(field.type).to(equal("checkbox"))
                                expect(field.required).to(equal(false))
                                expect(field.options.count).to(equal(2))
                                expect(field.fieldId).to(equal("SISSM"))
                                expect(field.fieldId).to(equal("SISSM"))
                                
                            }
                            
                            it("should containt a valid second field"){
                                let field: RatingFieldModel = formModel.pages[1].fields[1] as! RatingFieldModel
                                expect(field.fieldTitle).to(equal("Ik ben een slider!"))
                                expect(field.fieldId).to(equal("Ik_ben_een_slide"))
                                expect(field.type).to(equal("rating"))
                                expect(field.required).to(equal(false))
                                expect(field.scale).to(equal(5))
                                expect(field.high).to(equal("high >>"))
                                expect(field.low).to(equal("<< low"))
                                expect(field.shouldAppear()).to(equal(true))
                                
                            }
                            
                            it("should containt a valid email field"){
                                let field: EmailFieldModel = formModel.pages[1].fields[2] as! EmailFieldModel
                                expect(field.fieldTitle).to(equal("Email address"))
                                expect(field.fieldId).to(equal("email"))
                                expect(field.placeHolder).to(equal("Dit is een email"))
                                expect(field.required).to(equal(true))
                                expect(field.rule).toNot(beNil())
                                
                            }
                        }
                        
                    }
                    
                }
                
            }
            
            func testPerformanceExample() {
                // This is an example of a performance test case.
                self.measure {
                    //JSONFormParser.parseFormJson(jsonObj, appId: "a", screenshot: nil)
                }
            }
        }
    }
}
