//
//  UBXCScenario.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 27/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

extension XCUIElement {

    open func adjust(toIndex index: Int, withScale scale:Int = 6, withCorrection correction: CGFloat = 2) {
        
        // These positions are calculated and adjusted to work for all devices starting from iPhone 6.
        let positions: [CGFloat] = [40.0, 100.0, 160.0, 220.0, 280.0]
        let centerY = frame.size.height / 2
        let centerX = positions[index]
        
        let cooridnate = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: centerX, dy: centerY))
        cooridnate.press(forDuration: 0.1)
    }
    
    open func adjustNps(toIndex index: Int, withScale scale:Int = 5, withCorrection correction: CGFloat = 2) {
        let centerY = frame.size.height / 2
        let elementSize = frame.size.width / CGFloat(scale)
        let centerX = (elementSize * CGFloat(index)) + elementSize / correction
        let cooridnate = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: centerX, dy: centerY))
        cooridnate.press(forDuration: 0.1)
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

    func setUp(type: FormType, scenario: String, withScreenshot: Bool = false) {
        super.setUp()
        continueAfterFailure = false
        app.setup(type: type, scenario: scenario, withScreenshot: withScreenshot)
        app.launch()
    }

    func getTextViewText() -> String {
        let textView = app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .textView).element
        return textView.value as! String
    }
}
