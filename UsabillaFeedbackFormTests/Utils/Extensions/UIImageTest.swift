//
//  UIImageTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UIImageTest: QuickSpec {
    
    override func spec() {
        
        describe("UIImage") {
            let powered = Icons.imageOfPoweredBy(color: .blue)

            it("UIImage alpha") {
                let _ = powered.alpha(value: 0.3)
            }
            
            it("UIImage fix and size") {
                let fixed = powered.fixSizeAndOrientation()
                expect(fixed).to(equal(powered))
            }
            
            
            it("UIImage fix and size landscape") {
                UIGraphicsBeginImageContextWithOptions(CGSize(width: 900, height: 200), false, 0)
                let new = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                let fixed = new.fixSizeAndOrientation()
                expect(fixed).toNot(equal(powered))
                expect(fixed.size.width).to(equal(800))
            }
            
            
            it("UIImage fix and size portrait") {
                UIGraphicsBeginImageContextWithOptions(CGSize(width: 500, height: 1500), false, 0)
                let new = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                let fixed = new.fixSizeAndOrientation()
                expect(fixed).toNot(equal(powered))
                expect(fixed.size.height).to(equal(1200))
            }


        }
    }
}
