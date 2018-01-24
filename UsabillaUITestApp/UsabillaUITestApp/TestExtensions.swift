//
//  TestExtensions.swift
//  UsabillaUITestApp
//
//  Created by Giacomo Pinato on 24/01/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import XCTest

extension UBXCScenario {
    func verify(_ expression: @autoclosure () throws -> Bool, _ message : String = "unspecified error", _ timeout: Double = 5) {
        let expect = expectation(description: message)
        XCTAssert(expression, message)
        expect.fulfill()
        waitForExpectations(timeout: timeout) { (error) in
            if let error = error {
                print("oh no, \(error)")
            }
        }
    }
}
