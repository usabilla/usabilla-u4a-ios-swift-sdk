//
//  JSONParserTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//


import Quick
import Nimble
import SwiftyJSON


@testable import UsabillaFeedbackForm

class JSONParserTest: QuickSpec {
    
    override func spec() {
        
        var formModel: FormModel!
        
        beforeSuite {
            let path = NSBundle(forClass: JSONParserTest.self).pathForResource("test", ofType: "json")!
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj: JSON = JSON(data:data)
                formModel = JSONFormParser.parseFormJson(jsonObj, appId: "a", screenshot: nil)
                
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
                    expect(formModel.appTitle).to(equal("FeedbackTest"))
                    expect(formModel.appSubmitButton).to(equal("TestSubmit"))
                    expect(formModel.hasScreenshot).to(equal(true))
                    expect(formModel.version).to(equal(0))
                    expect(formModel.appId).to(equal("a"))
                    expect(formModel.isDefault).to(equal(false))
                    expect(formModel.errorMessage).to(equal("Error"))
                }
                
                describe("the pages array"){
                    
                    it("should have been correctly parsed"){
                        let pages = formModel.pages
                        expect(pages.count).to(equal(4))
                    }
                    
                    it("should contain a valid second page"){
                        let page = formModel.pages[1]
                        expect(page.pageName).to(equal("middle"))
                        expect(page.defaultJumpTo).to(equal("end"))
                        expect(page.jumpRuleList?.count).to(equal(1))

                    }
                    
                    
                }
                
            }
            
            func testPerformanceExample() {
                // This is an example of a performance test case.
                self.measureBlock {
                    //JSONFormParser.parseFormJson(jsonObj, appId: "a", screenshot: nil)
                }
            }
        }
    }
}
