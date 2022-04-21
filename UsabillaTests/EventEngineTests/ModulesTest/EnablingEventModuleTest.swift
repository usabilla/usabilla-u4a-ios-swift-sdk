//
//  EnablingEventModuleTest.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 10/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla

class EnablingEventModuleTest: XCTestCase {
    var module: EnablingEventModule?
    let surveyId = "23432-23432=2343-234"
    let targetId = "34531231"

    override func setUpWithError() throws {
        let enableModule = EnablingEventModule(comparison: .equal, moduleId: targetId + "_0")
        module = enableModule

        // remove old data before test
        if let theid = module?.moduleId {
            let data = DefaultEventModuleState(moduleType: DefaultEventModule.enable,
                                               surveyId: surveyId,
                                           moduleId: theid)
            DefaultEventModuleDAO.shared.delete(data)
        }
 
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNotUsed() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .surveyId, value: surveyId)
        let result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"The first evaluation should be false")
     }

    func testSetUsage() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .surveyId, value: surveyId)
        var result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"The first evaluation should be true - object has never been used")
        module?.setUsagedate(surveyId: surveyId)
        result = module?.evaluate(ovObject)
        XCTAssertEqual(result,false,"The first evaluation should be false")

     }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
