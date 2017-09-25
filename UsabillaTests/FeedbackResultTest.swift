//
//  FeedbackResultTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

import Usabilla

class FeedbackResultTest: QuickSpec {

    override func spec() {

        describe("FeedbackResult") {
            it("Test accessibility levels") {
                let t: FeedbackResult? = nil
                _ = t?.sent
                _ = t?.abandonedPageIndex
                _ = t?.rating
            }
        }
    }
}
