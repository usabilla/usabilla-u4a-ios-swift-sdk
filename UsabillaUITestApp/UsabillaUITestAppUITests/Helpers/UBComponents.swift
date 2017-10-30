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
        let floatValue = CGFloat(number) / 11.0 + 0.05
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
