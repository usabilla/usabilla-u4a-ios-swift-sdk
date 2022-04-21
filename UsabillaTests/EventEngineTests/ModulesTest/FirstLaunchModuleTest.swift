//
//  FirstLaunchModuleTest.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 19/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla

class FirstLaunchModuleTest: XCTestCase {
    var module: FirstLaunchEventModule?
    var otherModule: FirstLaunchEventModule?
    let surveyId = "111111-23432=2343-234"
    let targetId = "222222"

    override func setUpWithError() throws {
        var firstLaunchModule = FirstLaunchEventModule(value: true, moduleId: targetId + "_1")
        module = firstLaunchModule

        firstLaunchModule = FirstLaunchEventModule(value: false, moduleId: targetId + "_3")
        otherModule = firstLaunchModule

 
        
       // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // remove old data after test
        if let theid = module?.moduleId {
            let data = DefaultEventModuleState(moduleType: DefaultEventModule.firstLaunch,
                                               surveyId: surveyId,
                                           moduleId: theid)
            DefaultEventModuleDAO.shared.delete(data)
        }
        if let theid = otherModule?.moduleId {
            let data2 = DefaultEventModuleState(moduleType: DefaultEventModule.firstLaunch,
                                               surveyId: surveyId,
                                            moduleId: theid)
            DefaultEventModuleDAO.shared.delete(data2)
        }

    }

    func testFirstLaunchChanges() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .surveyId, value: surveyId)
        
        let result = module!.evaluate(ovObject)
        XCTAssertEqual(result,true,"The first evaluation should be true")

        let result2 = module!.evaluate(ovObject)
        XCTAssertEqual(result2,false,"The second evaluation should be false")

        let result3 = module!.evaluate(ovObject)
        XCTAssertEqual(result3,false,"The third evaluation should be false")
    }


    func testFirstLaunchNotRequired() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .surveyId, value: surveyId)
        
        let result = otherModule?.evaluate(ovObject)
        XCTAssertEqual(result,false,"First launch is false")

        let result2 = otherModule?.evaluate(ovObject)
        XCTAssertEqual(result2,true ,"Conscutive should be true")

        let result3 = otherModule?.evaluate(ovObject)
        XCTAssertEqual(result3,true ,"Conscutive should be true")

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
