//
//  AppVersionEventModuleTest.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 30/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla

class AppVersionEventModuleTest: XCTestCase {
    var module: AppVersionEventModule?
    var otherModule: AppVersionEventModule?
    let surveyId = "111111-23432=2343-234"
    let targetId = "222222"

    override func setUpWithError() throws {
        var appVersion = AppVersionEventModule(version: "2", comparison: .equal, platform: .ios)
        module = appVersion

        appVersion = AppVersionEventModule(version: "2.0.0", comparison: .lt, platform: .ios)
        otherModule = appVersion

        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLangVsShort() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .appVersion, value: "2.0.0")
        let result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"This should be true")
    }

    func testShortVsShort() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .appVersion, value: "2.0")
        let result = module?.evaluate(ovObject)
        XCTAssertEqual(result,true,"This should be true")
    }

    func testShortVsLong() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .appVersion, value: "1.9")
        let result = otherModule?.evaluate(ovObject)
        XCTAssertEqual(result,true,"This should be true")
    }

    func testSEquatable() throws {
        var ovObject = EvaluationObject()
        ovObject.add(key: .appVersion, value: "2.0.0")
        let result = otherModule?.evaluate(ovObject)
        XCTAssertEqual(result,false,"The first evaluation should be false")
    }

                     
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
