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

    func select(value: CGFloat) {
        nps.adjust(toNormalizedSliderValue: value)
    }
}
