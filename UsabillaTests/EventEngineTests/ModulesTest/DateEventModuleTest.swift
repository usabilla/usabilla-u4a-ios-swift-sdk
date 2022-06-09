//
//  DateEventModuleTest.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 09/06/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla

class DateEventModuleTest: XCTestCase {
    var module: DateEventModule?
    var otherModule: DateEventModule?
    let surveyId = "111111-23432=2343-234"
    let targetId = "222222"
    var dateFormatter = DateFormatter()

    override func setUpWithError() throws {
//        let now = Date()
//
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let aDate = dateFormatter.string(from: now)
//
//
        var firstLaunchModule = DateEventModule(date:"06/06/2022", comparison: ComparisonType.lt)
        module = firstLaunchModule

        firstLaunchModule = DateEventModule(date:"09/06/2022", comparison: ComparisonType.equal)
        otherModule = firstLaunchModule

 
        
       // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
    }

    func testLesThan() throws {
        let now  = Date().toRFC3339Format()
        var ovObject = EvaluationObject()        
        ovObject.add(key: .currentTime, value: now)
        let result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"This should be true")

        let result1 = otherModule?.evaluate(ovObject)
        XCTAssertEqual(result1,true,"This should be true")

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
