//
//  PassiveStatusTests.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 08/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class PassiveStatusTests: QuickSpec {

    override func spec() {

        describe("PassiveStatus") {
            context("when initalised") {
                it("Is initialised correctly with valid data") {
                    var passiveStatus = PassiveStatus(name: PassiveStatus.PasstiveStatusType.language, value: "fr")
                    expect(passiveStatus.name.rawValue).to(equal("language"))
                    expect(passiveStatus.value).to(equal("fr"))
                    // change format and check language again
                    passiveStatus = PassiveStatus(name: PassiveStatus.PasstiveStatusType.language, value: "en_US")
                    expect(passiveStatus.value).to(equal("en_US"))
                }
                it("should serialize correctly") {
                    let passiveStatus = PassiveStatus(name: PassiveStatus.PasstiveStatusType.language, value: "fr")
                    let data = NSKeyedArchiver.archivedData(withRootObject: passiveStatus)

                    expect(data).toNot(beNil())
                    // swiftlint:disable force_cast
                    let unserialised = NSKeyedUnarchiver.unarchiveObject(with: data) as! PassiveStatus
                    expect(unserialised.name.rawValue).to(equal("language"))
                    expect(unserialised.value).to(equal("fr"))
                }
            }
        }
    }
}
