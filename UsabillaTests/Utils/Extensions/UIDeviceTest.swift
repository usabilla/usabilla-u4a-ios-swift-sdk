//
//  UIDeviceTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UIDeviceTest: QuickSpec {

    override func spec() {

        describe("UIDevice") {

            it("UIDevice modelName") {
                expect(UIDevice.current.modelName).to(equal("x86_64"))
            }

        }
    }
}
