//
//  TestSetup.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 23/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest
@testable import UsabillaUITestApp

extension XCUIApplication {
    
    enum FormType: String {
        case campaignForm
        case passiveForm
    }

    func setup(type: FormType, scenario: String) {
        launchEnvironment["scenario"] = scenario
        launchEnvironment["formType"] = type.rawValue
    }
}
