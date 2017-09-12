//
//  MainScreen.swift
//  UsabillaFeedbackFormUITestApp
//
//  Created by Benjamin Grima on 27/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import XCTest

struct MainScreen {
    static let app = XCUIApplication()
    var nps = app.tables.otherElements["Select a score"]
}
