//
//  DeviceInfoTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class DeviceInfoTest: QuickSpec {
    
    override func spec() {
        
        describe("DeviceInfo") {
            it("DeviceIno isJailBroken") {
                let t = DeviceInfo.isJailbroken()
                expect(t).to(beFalse())
            }
            
            it("DeviceIno totalDiskSpace") {
                let t = DeviceInfo.DiskStatus.totalDiskSpaceInBytes
                expect(t).to(beGreaterThan(0))
            }
            
            it("DeviceIno freeDiskSpace") {
                let t = DeviceInfo.DiskStatus.freeDiskSpaceInBytes
                expect(t).to(beGreaterThan(0))
            }
        }
    }
}
