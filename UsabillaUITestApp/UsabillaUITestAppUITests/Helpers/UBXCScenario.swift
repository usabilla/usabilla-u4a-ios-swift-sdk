//
//  UBXCScenario.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 27/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

extension XCUIElement {
    open func adjust(toNormalizedSliderValue normalizedSliderValue: CGFloat) {
        let start = coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
        let end = coordinate(withNormalizedOffset: CGVector(dx: normalizedSliderValue, dy: 0.0))
        start.press(forDuration: 0.05, thenDragTo: end)
    }
    
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}

class UBXCScenario: XCTestCase {
    let app = Application.xcApp

    func setUp(type: FormType, scenario: String) {
        super.setUp()
        continueAfterFailure = false
        app.setup(type: type, scenario: scenario)
        app.launch()
    }

    func getTextViewText() -> String {
        let textView = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .textView).element
        return textView.value as! String
    }
}
