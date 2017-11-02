//
//  UBComponents.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 25/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import XCTest

// Main Application
struct Application {
    static let xcApp = XCUIApplication()
    let banner = Banner()
}

struct Banner {
    let element: XCUIElement
    let cancelButton: XCUIElement
    let continueButton: XCUIElement
    init() {
        element = Application.xcApp.otherElements["banner"]
        cancelButton = element.buttons["Cancel"]
        continueButton = element.buttons["Continue"]
    }
}

struct Modal {
    let form: Form
    init() {
        form = Form(element: Application.xcApp.otherElements["form-navigation-controller"])
    }
}

struct Form {
    let element: XCUIElement
    var navigationBar: NavigationBar {
        return NavigationBar(element: element.navigationBars.allElementsBoundByIndex.first!)
    }
    init(element: XCUIElement) {
        self.element = element
    }
}

struct Toast {
    let element: XCUIElement
    var text: String? {
        return element.staticTexts.allElementsBoundByIndex.first?.label
    }

    init() {
        element = Application.xcApp.otherElements["toast"]
    }
}

struct NavigationBar {
    let element: XCUIElement
    let cancelButton: XCUIElement
    let nextButton: XCUIElement
    init(element: XCUIElement) {
        self.element = element
        cancelButton = element.buttons["Cancel"]
        nextButton = element.buttons["Next"]
    }
}

// The banner view with NPS component
struct BannerViewNPS {
    let nps = NPSComponent()
}

// NPS Component
struct NPSComponent {
    let nps = Application.xcApp.otherElements["Select a score"]

    // selects an NPS value
    func select(number: Int) {
        let floatValue = CGFloat(number) / 11.0 + (1 / 11.0) / 2
        nps.adjust(toNormalizedSliderValue: floatValue)
    }
}

// Mood Component
class MoodComponent {
    var mood: XCUIElementQuery? = nil

    func selectMood(atIndex index: UInt) {
        mood?.element(boundBy: index).tap()
    }
}

class MoodComponentCampaign: MoodComponent {
    override init() {
        super.init()
        self.mood = Application.xcApp.otherElements["ratingControl"].children(matching: .other).element.children(matching: .button)
    }
}

class MoodComponentPassive: MoodComponent {
    override init() {
        super.init()
        self.mood = Application.xcApp.tables.children(matching: .cell).element(boundBy: 0).children(matching: .button)
    }
}
