//
//  PageControllerTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 23/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import UsabillaFeedbackForm

class PageControllerTest: QuickSpec {
    
    override func spec() {
        var pageController: PageController!
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
            
            let storyboard = UIStoryboard(name: "USAStoryboard", bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
            let base = storyboard.instantiateViewControllerWithIdentifier("base") as! UINavigationController
            let viewController = base.childViewControllers[0] as! FormViewController
            viewController.initWithFormModel(formModel)
            pageController = viewController.pageController
            //viewController.
        }
        
        beforeEach {
            
        }
    }
}
