//
//  CacheManagerTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 17/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm


class CacheManagerTests: QuickSpec {
    
    var formModel: FormModel!
    let formId = "formId"
    
    override func spec() {
        
        describe("CacheManagerTests") {
            
            beforeEach {
                let path = Bundle(for: FormModelTest.self).path(forResource: "test", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: (data as? Data)!)
                self.formModel = JSONFormParser.parseFormJson(jsonObj, appId: self.formId, screenshot: nil, themeConfig: UsabillaThemeConfigurator())
            }
            
            context("When saving form into cache", {
                it("should succeed", closure: {
                    let succeeded = CacheManager.sharedInstance.cacheForm(id: self.formId, form: self.formModel)
                    expect(succeeded).to(beTrue())
                })
            })
            
            context("When getting cache form CacheManager", {
                it("should succeed getting the form if it exists", closure: {
                    let succeeded = CacheManager.sharedInstance.cacheForm(id: self.formId, form: self.formModel)
                    expect(succeeded).to(beTrue())
                    
                    let form = CacheManager.sharedInstance.getForm(id: self.formId)
                    expect(form).toNot(beNil())
                    expect(form?.appId).to(equal(self.formModel.appId))
                    expect(form?.formJsonString).to(equal(self.formModel.formJsonString))
                })
                it("should return nil getting a form that does not exist", closure: {
                    let form = CacheManager.sharedInstance.getForm(id: "nonExistingFormID")
                    expect(form).to(beNil())
                })
            })
            
            context("When removing a form from cache", { 
                it("should succeed if form it's cached already ", closure: {
                    // Save -> cache
                    let succeeded = CacheManager.sharedInstance.cacheForm(id: "formIdToBeRemoved", form: self.formModel)
                    expect(succeeded).to(beTrue())
                    
                    // Remove
                    let resultRemove = CacheManager.sharedInstance.removeCachedForm(id: "formIdToBeRemoved")
                    expect(resultRemove).to(beTrue())
                    
                    // Should not be able to get it
                    let form = CacheManager.sharedInstance.getForm(id: "formIdToBeRemoved")
                    expect(form).to(beNil())
                })
                it("should fail if form is not found in cache", closure: {
                    let form = CacheManager.sharedInstance.getForm(id: "NonExistingformIdToBeRemoved")
                    expect(form).to(beNil())
                    
                    let resultRemove = CacheManager.sharedInstance.removeCachedForm(id: "NonExistingformIdToBeRemoved")
                    expect(resultRemove).to(beFalse())
                })
            })
            
            context("When removing all forms", {
                it("should succeed when there is cached forms", closure: {
                    // Save 2 forms -> cache
                    let succeeded1 = CacheManager.sharedInstance.cacheForm(id: "formId1", form: self.formModel)
                    expect(succeeded1).to(beTrue())
                    let succeeded2 = CacheManager.sharedInstance.cacheForm(id: "formId2", form: self.formModel)
                    expect(succeeded2).to(beTrue())
                    
                    // Remove all forms
                    let resultRemoving = CacheManager.sharedInstance.removeAllCachedForms()
                    expect(resultRemoving).to(beTrue())
                    
                    // Should not be able to get it
                    expect(CacheManager.sharedInstance.getForm(id: "formId1")).to(beNil())
                    expect(CacheManager.sharedInstance.getForm(id: "formId2")).to(beNil())
                })
                it("should fail when there is no cached forms", closure: { 
                    let resultRemoving = CacheManager.sharedInstance.removeAllCachedForms()
                    expect(resultRemoving).to(beFalse())
                })
            })
        }
    }
}
