//
//  Performance.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 09/11/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import XCTest
@testable import UsabillaFeedbackForm

class Performance: XCTestCase {
    
    var jsonObj: JSON!
    var base64image: String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
        do {
            let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            jsonObj = JSON(data:data as Data)
            
        } catch let error as NSError {
            Swift.debugPrint(error.localizedDescription)
        }
        
        
        let image = UIImage(named: "a", in: Bundle(for: Performance.self), compatibleWith: nil)!
        let data = UIImageJPEGRepresentation(image, 0.5)
        base64image =  data?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    
    func testChunkingPerformance() {
        // This is an example of a performance test case.
        self.measure {
            self.base64image.divideInChunksOfSize(15000)
        }
    }
    
    func testJSONParserPerformance() {
        // This is an example of a performance test case.
        self.measure {
            JSONFormParser.parseFormJson(self.jsonObj, appId: "a", screenshot: nil, themeConfig:  UsabillaThemeConfigurator())
        }
    }
    
    
    func testLoadingTime() {
        // This is an example of a performance test case.
        self.measure {
            var formModel:FormModel? = nil
            let path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
            do {
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data:data as Data)
                formModel = JSONFormParser.parseFormJson(jsonObj, appId: "a", screenshot: nil, themeConfig: UsabillaThemeConfigurator())
                
            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }
            
            let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
            let base = storyboard.instantiateViewController(withIdentifier: "base") as! UINavigationController
            let viewController = base.childViewControllers[0] as! FormViewController
            viewController.initWithFormModel(formModel!)
            //viewController.
            
            // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
        }
    }
    
}
