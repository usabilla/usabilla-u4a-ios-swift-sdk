//
//  TimeEventModule.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 09/06/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla
class TimeEventModuleTest: XCTestCase {
    var module: TimeEventModule?
    var otherModule: TimeEventModule?
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
        var firstLaunchModule = TimeEventModule(time: "12:50", comparison: .equal)
        module = firstLaunchModule

        firstLaunchModule = TimeEventModule(time: "13:00", comparison: .gte)
        otherModule = firstLaunchModule

 
        
       // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testTimes() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .currentTime, value: "2022-06-09T10:50:00z")
        let result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"This should be true")

        let result1 = otherModule?.evaluate(ovObject)
        XCTAssertEqual(result1,false,"This should be true")

    }

    func testSomeTimes() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .currentTime, value: "2022-06-09T14:50:00z")
        let result = module?.evaluate(ovObject)
        XCTAssertEqual(result,false,"This should be true")

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
