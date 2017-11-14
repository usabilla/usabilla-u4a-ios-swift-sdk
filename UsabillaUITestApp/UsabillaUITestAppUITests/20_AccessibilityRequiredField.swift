//
//  20_AccessibilityRequiredField.swift
//  UsabillaUITestAppUITests
//
//  Created by Benjamin Grima on 16/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

class AccessibilityRequiredField: UBXCScenario {

    override func setUp() {
        super.setUp(type: .passiveForm, scenario: "20_AccessibilityRequiredField")
    }
    
    func testMoodComponentLabelAndValues() {
        let moodCell = app.tables.cells.element(boundBy: 0)
        XCTAssertEqual(moodCell.label, "Select a mood This field is required")
        
        let textAreaCell = app.tables.cells.element(boundBy: 1)
        XCTAssertEqual(textAreaCell.label, "What do you think about us?")
    }
}
