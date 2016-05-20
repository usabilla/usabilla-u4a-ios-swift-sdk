//
//  CarrierPidgeonTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 19/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import XCTest

class CarrierPidgeonTest: XCTestCase {
    
    var carrierPidgeon: CarrierPidgeon? = nil

    override func setUp() {
        super.setUp()
        carrierPidgeon = CarrierPidgeon(fieldID: "asd", fieldValue: "dieci")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(carrierPidgeon?.fieldID == "asd")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
