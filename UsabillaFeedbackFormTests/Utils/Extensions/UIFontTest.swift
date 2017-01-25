//
//  UIFontTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UIFontTest: QuickSpec {

    override func spec() {

        describe("UIFont") {
            let font = UIFont.systemFont(ofSize: 10)

            it("UIFont bold") {
                let bold = font.bold()
                expect(bold?.fontDescriptor.symbolicTraits.contains(.traitBold)).to(beTrue())
            }
            it("UIFont italic") {
                let bold = font.italic()
                expect(bold?.fontDescriptor.symbolicTraits.contains(.traitItalic)).to(beTrue())
            }
            it("UIFont bold italic") {
                let bold = font.boldItalic()
                expect(bold?.fontDescriptor.symbolicTraits.contains(.traitBold)).to(beTrue())
                expect(bold?.fontDescriptor.symbolicTraits.contains(.traitItalic)).to(beTrue())

            }

            it("UIFont with traits fails") {
                let arial = UIFont(name: "Arial", size: 10)
                expect(arial?.withTraits(UIFontDescriptorSymbolicTraits.traitExpanded)).to(beNil())
            }

        }

    }
}
