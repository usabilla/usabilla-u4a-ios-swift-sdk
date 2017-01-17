//
//  UsabillaThemeConfiguratorTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 17/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UsabillaThemeConfiguratorTest: QuickSpec {

    override func spec() {
        var theme: UsabillaThemeConfigurator?

        describe("UsabillaThemeConfigurator") {
            it("init UsabillaThemeConfigurator") {
                theme = UsabillaThemeConfigurator()
                expect(theme).toNot(beNil())
                expect(theme?.enabledEmoticons.count).to(equal(5))
                expect(theme?.headerColor).to(beNil())
                expect(theme?.customFont).to(beNil())
                expect(theme?.hintColor).to(equal(theme?.textColor.withAlphaComponent(0.38)))
            }

            it("UsabillaThemeConfigurator font") {
                expect(theme?.font).to(equal(UIFont.systemFont(ofSize: UIFont.systemFontSize)))
                theme?.customFont = UIFont.systemFont(ofSize: 50)
                expect(theme?.font).to(equal(UIFont.systemFont(ofSize: 50)))
            }

        }
    }
}
