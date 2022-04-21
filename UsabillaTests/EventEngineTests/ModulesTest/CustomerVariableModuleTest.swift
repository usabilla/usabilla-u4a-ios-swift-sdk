//
//  CustomerVariableModuleTest.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 12/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla

class CustomerVariableModuleTest: XCTestCase {
    var module: CustomerVariableModule?
    let surveyId = "23432-23432=2343-234"
    let targetId = "34531231"

    override func setUpWithError() throws {
        let customerModule = CustomerVariableModule(key: "level", value: "25", comparison: .equal)
        module = customerModule

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var ovObject = EvaluationObject()
        ovObject.addCustomerVariables(["horse":"black","level":"25"])
        let result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"The first evaluation should be true")
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
