//
//  StyleKitTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 23/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class StyleKitTest: QuickSpec {

    override func spec() {

        describe("StyleKit") {
            it("StyleKit icons imageOfEdit") {
                let a = Icons.imageOfEdit(color: .white)
                let b = Icons.imageOfEdit(color: .white) // second time for the cache

                expect(a).to(equal(b))
            }

            it("StyleKit icons imageOfAdd") {
                let a = Icons.imageOfAddImage(color: .white)
                let b = Icons.imageOfAddImage(color: .white) // second time for the cache

                expect(a).to(equal(b))
            }

            it("StyleKit icons imageOfDelete") {
                let a = Icons.deleteIcon(color: .white)
                let b = Icons.deleteIcon(color: .white) // second time for the cache

                expect(a).to(equal(b))
            }
            it("StyleKit icons imageOfLogo") {
                let a = Icons.imageOfPoweredBy(color: .white)
                let b = Icons.imageOfPoweredBy(color: .white) // second time for the cache

                expect(a).to(equal(b))
            }
        }
    }
}
