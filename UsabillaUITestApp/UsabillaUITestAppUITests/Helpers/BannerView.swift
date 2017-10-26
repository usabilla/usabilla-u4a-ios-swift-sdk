//
//  BannerView.swift
//  UsabillaUITestAppUITests
//
//  Created by Adil Bougamza on 25/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import XCTest

struct BannerView {
    static let app = XCUIApplication()
    static let nps = app.otherElements["Select a score"]
    static private let npsMax = 11

    static func selectNPS(withValue value: CGFloat) {
        nps.adjust(toNormalizedSliderValue: value)
    }
}
