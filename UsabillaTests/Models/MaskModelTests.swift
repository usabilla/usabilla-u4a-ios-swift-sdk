//
//  MaskModelTests.swift
//  UsabillaTests
//
//  Created by Anders Liebi on 05/04/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class MaskModelTests: QuickSpec {
    override func spec() {
        var maskModel: MaskModel!
        describe("Init MaskModel ") {
            beforeEach {
                maskModel = MaskModel(maskCharacter: "*", masks: ["[0-9]{4,}", "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"])
            }
            
            context("When Masking text") {
                it("Should mask number-groups 4 or longer") {
                    let text = "1 12 123 1234 12345 123456"
                    let masked = maskModel.toMaskText(text) ?? ""
                    expect(masked).to(equal("1 12 123 **** ***** ******"))
                }
                it("Should mask number-groups 4 or longer also embedde") {
                    let text = "This is my social security-number:12345-121313"
                    let masked = maskModel.toMaskText(text) ?? ""
                    expect(masked).to(equal("This is my social security-number:*****-******"))
                }
                it("Should mask Credit Cards") {
                    let text = "1234 1234 1234 1234"
                    let masked = maskModel.toMaskText(text) ?? ""
                    expect(masked).to(equal("**** **** **** ****"))
                }
                it("Should mask emails") {
                    let text = "maskme@usabilla.com"
                    let masked = maskModel.toMaskText(text) ?? ""
                    expect(masked).to(equal("*******************"))
                }
            }
        }
    }
}
