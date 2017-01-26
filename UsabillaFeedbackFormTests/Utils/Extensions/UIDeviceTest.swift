//
//  UIDeviceTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UIDeviceTest: QuickSpec {

    override func spec() {

        describe("UIDevice") {
            let models: [String: [String]] = [
                "iPod Touch 5": ["iPod5,1"],
                "iPod Touch 6": ["iPod7,1"],
                "iPhone 4": ["iPhone3,1", "iPhone3,2", "iPhone3,3"],
                "iPhone 4s": ["iPhone4,1"],
                "iPhone 5": ["iPhone5,1", "iPhone5,2"],
                "iPhone 5c": ["iPhone5,3", "iPhone5,4"],
                "iPhone 5s": ["iPhone6,1", "iPhone6,2"],
                "iPhone 6": ["iPhone7,2"],
                "iPhone 6 Plus": ["iPhone7,1"],
                "iPhone 6s": ["iPhone8,1"],
                "iPhone 6s Plus": ["iPhone8,2"],
                "iPhone 7": ["iPhone9,1", "iPhone9,3"],
                "iPhone 7 Plus": ["iPhone9,2", "iPhone9,4"],
                "iPhone SE": ["iPhone8,4"],
                "iPad 2": ["iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4"],
                "iPad 3": ["iPad3,1", "iPad3,2", "iPad3,3"],
                "iPad 4": ["iPad3,4", "iPad3,5", "iPad3,6"],
                "iPad Air": ["iPad4,1", "iPad4,2", "iPad4,3"],
                "iPad Air 2": ["iPad5,3", "iPad5,4"],
                "iPad Mini": ["iPad2,5", "iPad2,6", "iPad2,7"],
                "iPad Mini 2": ["iPad4,4", "iPad4,5", "iPad4,6"],
                "iPad Mini 3": ["iPad4,7", "iPad4,8", "iPad4,9"],
                "iPad Mini 4": ["iPad5,1", "iPad5,2"],
                "iPad Pro": ["iPad6,7", "iPad6,8"],
                "Apple TV": ["AppleTV5,3"],
                "Simulator": ["i386", "x86_64"]
            ]
            it("UIDevice modelName") {
                expect(UIDevice.current.modelName).to(equal("Simulator"))
            }

            it("UIDevice model for identifier") {
                for (model, identifiers) in models {
                    for identifier in identifiers {
                        expect(UIDevice.model(identifier: identifier)).to(equal(model))
                    }
                }
            }

            it("UIDevice model for identifier") {
                expect(UIDevice.model(identifier: "test")).to(equal("test"))
            }

        }
    }
}
