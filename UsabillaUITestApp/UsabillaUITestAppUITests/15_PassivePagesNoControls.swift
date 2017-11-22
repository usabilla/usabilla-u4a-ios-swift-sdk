//
//  15_PassivePagesNoControls.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 02/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class PassivePagesNoControls: UBXCScenario {

    let form = Form()
    let mood = MoodComponentPassive()
    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "15_PassivePagesNoControls")
    }

    func testPagesNoControls() {
        XCTAssert(form.element.exists)
        mood.selectMood(atIndex: 0)
        form.navigationBar.nextButton.tap() // Displays Page 2
        form.navigationBar.submitButton.tap() // Displays End Page
    }
}
