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

struct MainScreen {
    let nps = NPSComponent()

    func selectOption(withLabel label: String) {
        Application.xcApp.tables.otherElements[label].tap()
    }
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
        form = Form()
    }
}

struct Form {
    let element: XCUIElement
    var navigationBar: NavigationBar {
        return NavigationBar(element: element.navigationBars.allElementsBoundByIndex.first!)
    }
    init(element: XCUIElement = Application.xcApp.otherElements["form-navigation-controller"]) {
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
    let submitButton: XCUIElement
    init(element: XCUIElement) {
        self.element = element
        cancelButton = element.buttons["Cancel"]
        nextButton = element.buttons["Next"]
        submitButton = element.buttons["Submit"]
    }
}

// The banner view with NPS component
struct BannerViewNPS {
    let nps = NPSComponent()
} 

// NPS Component
struct NPSComponent {
    let element: XCUIElement = Application.xcApp.otherElements["Select a score"]

    // selects an NPS value
    func select(index: Int) {
        element.adjust(toIndex: index, withScale: 11)
    }
}

// Mood Component
class MoodComponent {
    var mood: XCUIElement!

    func selectMood(atIndex index: UInt) {
        mood.adjust(toIndex: Int(index), withCorrection: 2.5)
    }
}

class MoodComponentCampaign: MoodComponent {
    override init() {
        super.init()
        self.mood = Application.xcApp.otherElements["ratingControl"]
    }
}

class MoodComponentPassive: MoodComponent {
    override init() {
        super.init()
        self.mood = Application.xcApp.tables.children(matching: .cell).otherElements["ratingControl"]
    }
}