//
//  TestExtensions.swift
//  UsabillaUITestApp
//
//  Created by Giacomo Pinato on 24/01/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import XCTest

enum Mood: String {
    case hate = "I really don't like it"
    case dislike = "I don't like it"
    case neutral = "I feel neutral"
    case like = "I like it"
    case love = "I love it"
}

enum Star: String {
    case oneStar = "1 star"
    case twoStars = "2 stars"
    case threeStars = "3 stars"
    case fourStars = "4 stars"
    case fiveStars = "5 stars"
}

extension UBXCScenario {
    func verify(_ expression: @autoclosure () throws -> Bool, _ message: String = "unspecified error", _ timeout: Double = 5) {
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
