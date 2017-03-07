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

            context("when UsabillaThemeConfigurator is initilized", {
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
            })

            context("when UsabillaThemeConfigurator enabledEmoticons count is different than 5 images", {
                it("should be nil", closure: {
                    expect(theme?.emoticons(size: 5, emoticons: [UIImage(), UIImage()])).to(beNil())
                })
            })

            context("when mood array contains different sizes mood arrays", {
                it("should return an array of only 2 emoticon images", closure: {
                    expect(theme?.emoticons(size: 2, emoticons: theme?.enabledEmoticons)?.count).to(equal(2))
                })
                it("should return an array of only three emoticon images", closure: {
                    expect(theme?.emoticons(size: 3, emoticons: theme?.enabledEmoticons)?.count).to(equal(3))
                })
                it("should return an array of only five emoticon images", closure: {
                    expect(theme?.emoticons(size: 5, emoticons: theme?.enabledEmoticons)?.count).to(equal(5))
                })
            })
        }
    }
}
