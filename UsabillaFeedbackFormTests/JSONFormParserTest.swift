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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            JSONFormParser.parseFormJson(self.jsonObj, appId: "a", screenshot: nil, themeConfig:  UsabillaThemeConfigurator())
        }
    }
    
}
