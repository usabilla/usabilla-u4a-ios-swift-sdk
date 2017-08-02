//
//  ActiveStatusTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 02/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class ActiveStatusTests: QuickSpec {
    
    override func spec() {
        
        describe("ActiveStatus") {
            context("when initalised") {
                it("Is initialised correctly with valid data") {
                    let activeStatus = ActiveStatus(name: "key", value: "value")
                    expect(activeStatus.name).to(equal("key"))
                    expect(activeStatus.value).to(equal("value"))
                }
            }
        }
    }
}
