//
//  UBXCScenario.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 27/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import XCTest

extension XCUIElement {

    
    open func adjust(toIndex index: Int, withScale scale:Int = 6, withCorrection correction: CGFloat = 2, totalMoods: Int) {
        
        var positions: [CGFloat] = createArrayOfMoodsPostions(totalMoods)
        let centerY = frame.size.height / 2
        let centerX = positions[index]
        
        let cooridnate = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: centerX, dy: centerY))
        cooridnate.press(forDuration: 0.1)
    }
    
    
    private func createArrayOfMoodsPostions(_ moodCount: Int) -> [CGFloat] {
        switch moodCount {
        case 2:
            return [frame.size.width/2-25-21,frame.size.width/2+25+21]
        case 3:
            let space = (frame.size.width-3*42)/5
            return [frame.size.width/2-space-42,frame.size.width/2,frame.size.width/2+space+42]
        default:
            let space = CGFloat((Int(frame.size.width)-5*42)/5)

            return [frame.size.width/2-(space+42)*2,frame.size.width/2-space-42,frame.size.width/2, frame.size.width/2+space+42, frame.size.width/2+(space+42)*2]  
        }

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
        return self.frame.size.height > 5
            //XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
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
