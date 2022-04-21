//
//  PercentageModuleTest.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 17/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla

class TargetingModuleTest: XCTestCase {
    var module: TargetingEventModule?
    var otherModule: TargetingEventModule?
    let surveyId = "23432-23432=2343-234"
    let targetId = "84388353"

    override func setUpWithError() throws {
        var percentageModule = TargetingEventModule(value: 45, comparison: .gt, moduleId: targetId + "_1")
        module = percentageModule

        percentageModule = TargetingEventModule(value: 90, comparison: .gt, moduleId: targetId + "_3")
        otherModule = percentageModule

        // remove old data before test
        if let theid = module?.moduleId {
            let data = DefaultEventModuleState(moduleType: DefaultEventModule.targeting,
                                               surveyId: surveyId,
                                           moduleId: theid)
            DefaultEventModuleDAO.shared.delete(data)
        }
        if let theid = otherModule?.moduleId {
            let data2 = DefaultEventModuleState(moduleType: DefaultEventModule.targeting,
                                               surveyId: surveyId,
                                            moduleId: theid)
            DefaultEventModuleDAO.shared.delete(data2)
        }

        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPercentage() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .surveyId, value: surveyId)
        ovObject.add(key: .targetingProcentage , value: "95")
        let result = module?.evaluate(ovObject)
        
        XCTAssertEqual(result,true,"The first evaluation should be true")

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    func testInternal() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .surveyId, value: surveyId)
        var result = module?.evaluate(ovObject)
        
        let value1 = module!.getCurrentPercentage(surveyId: surveyId, moduleId: module!.moduleId)
        result = module?.evaluate(ovObject)
        let value2 = module!.getCurrentPercentage(surveyId: surveyId, moduleId: module!.moduleId)
        XCTAssertEqual(value1 == value2,true,"The first evaluation should be true")

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
