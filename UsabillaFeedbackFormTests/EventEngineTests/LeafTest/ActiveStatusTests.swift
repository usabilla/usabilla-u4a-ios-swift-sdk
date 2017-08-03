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
                it("should serialize correctly") {
                    let activeStatus = ActiveStatus(name: "key", value: "value")
                    let data = NSKeyedArchiver.archivedData(withRootObject: activeStatus)

                    expect(data).toNot(beNil())
                    // swiftlint:disable force_cast
                    let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! ActiveStatus
                    expect(unserialised.name).to(equal("key"))
                    expect(unserialised.value).to(equal("value"))
                }
            }
        }
    }
}
