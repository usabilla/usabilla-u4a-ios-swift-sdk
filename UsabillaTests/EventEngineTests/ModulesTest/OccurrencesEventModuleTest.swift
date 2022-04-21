//
//  OccurrencesEventModuleTest.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 06/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla

class OccurrencesEventModuleTest: XCTestCase {

    var module: OccurrencesEventModule?
    var othermodule: OccurrencesEventModule?
    let surveyId = "23432-23432=2343-234"
    let targetId = "34531231"
    override func setUpWithError() throws {
        var occurrenceModule = OccurrencesEventModule(counter: 3, comparison: .gte, moduleId: targetId + "_1")
        module = occurrenceModule

        occurrenceModule = OccurrencesEventModule(counter: 1, comparison: .gte, moduleId: targetId + "_3")
        othermodule = occurrenceModule

        // remove old data before test
        if let theid = module?.moduleId {
            let data = DefaultEventModuleState(moduleType: DefaultEventModule.occurrences,
                                               surveyId: surveyId,
                                           moduleId: theid)
            DefaultEventModuleDAO.shared.delete(data)
        }
        if let theid = othermodule?.moduleId {
            let data2 = DefaultEventModuleState(moduleType: DefaultEventModule.occurrences,
                                               surveyId: surveyId,
                                            moduleId: theid)
            DefaultEventModuleDAO.shared.delete(data2)
        }

        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCounter() throws {
        
        var ovObject = EvaluationObject()
        ovObject.add(key: .surveyId, value: surveyId)
        var result = module?.evaluate(ovObject)
        XCTAssertEqual(result,false,"The first evaluation should be false")
        result = module?.evaluate(ovObject)
        XCTAssertEqual(result,false,"The second evaluation should be false")
        result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"The third evaluation should be true")
        result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"The 4'th evaluation should be true")
        result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"The 5'th evaluation should be true")

        
    }

    func testMutipleCounters() throws {
        
        var ovObject = EvaluationObject()
        ovObject.add(key: .surveyId, value: surveyId)

        var ov2Object = EvaluationObject()
        ov2Object.add(key: .surveyId, value: surveyId)

        var result = module?.evaluate(ovObject)
        XCTAssertEqual(result,false,"The first evaluation should be false")
        result = module?.evaluate(ovObject)
        XCTAssertEqual(result,false,"The second evaluation should be false")
        result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"The third evaluation should be false")
        result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"The 4'th evaluation should be true")
        result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"The 5'th evaluation should be true")

        result = othermodule?.evaluate(ov2Object)
        XCTAssertEqual(result,true,"The first evaluation should be false")
        result = othermodule?.evaluate(ov2Object)
        XCTAssertEqual(result,true,"The 2'nd evaluation should be true")

        
    }

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
