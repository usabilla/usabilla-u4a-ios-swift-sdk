//
//  UsabillaThemeTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 17/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UsabillaThemeTests: QuickSpec {

    override func spec() {
        var theme: UsabillaTheme!

        describe("UsabillaTheme") {

            beforeEach {
                theme = UsabillaTheme()
            }

            context("when UsabillaTheme is initilized") {
                it("init UsabillaTheme") {
                    expect(theme).toNot(beNil())
                    expect(theme.images.enabledEmoticons.count).to(equal(5))
                    expect(theme.colors.header).to(beNil())
                    expect(theme.colors.hint).to(equal(theme.colors.text.withAlphaComponent(0.38)))
                    expect(theme.fonts.font).to(equal(UIFont.uSystemFont(ofSize: 17, weight: .regular)))
                    expect(theme.fonts.bold).to(beNil())
                    expect(theme.statusBarStyle).to(beNil())
                }
                it("UsabillaTheme font") {
                    theme.fonts.bold = UIFont.uSystemFont(ofSize: 17, weight: .semiBold)
                    expect(theme.fonts.bold).to(equal(UIFont.uSystemFont(ofSize: 17, weight: .semiBold)))
                }
                it("should set status bar color with correct value") {
                    theme.statusBarStyle = .default
                    expect(theme).toNot(beNil())
                    expect(theme.statusBarStyle).toNot(beNil())
                }
            }

            context("when fonts are set") {
                it("should return the font set by user") {
                    let customRegularFont = UIFont(name: "Avenir-Book", size: 14)
                    let customBoldFont = UIFont(name: "Avenir-Heavy", size: 15)
                    theme.fonts.regular = customRegularFont
                    theme.fonts.bold = customBoldFont
                    theme.fonts.textSize = 14
                    theme.fonts.titleSize = 15
                    expect(theme.fonts.font).to(equal(UIFont(name: "Avenir-Book", size: 14)))
                    expect(theme.fonts.boldFont).to(equal(UIFont(name: "Avenir-Heavy", size: 15)))
                }
            }

            context("when UsabillaTheme enabledEmoticons count is different than 5 images") {
                it("should be nil", closure: {
                    expect(theme?.emoticons(size: 5, emoticons: [UIImage(), UIImage()])).to(beNil())
                })
            }

            context("when mood array contains different sizes mood arrays", {
                it("should return an array of only 2 emoticon images", closure: {
                    expect(theme?.emoticons(size: 2, emoticons: theme.images.enabledEmoticons)?.count).to(equal(2))
                })
                it("should return an array of only three emoticon images", closure: {
                    expect(theme?.emoticons(size: 3, emoticons: theme.images.enabledEmoticons)?.count).to(equal(3))
                })
                it("should return an array of only five emoticon images", closure: {
                    expect(theme?.emoticons(size: 5, emoticons: theme.images.enabledEmoticons)?.count).to(equal(5))
                })
            })

            context("When parsing theme colors from OLD json without card design color") {
                // Arrange
                var uTheme = UsabillaTheme()
                let colorsJson = UBMock.json("ThemeJsonNoCardColor")?["colors"]
                uTheme.updateColors(json: colorsJson!)

                it("should parse the correct colors") {
                    expect(uTheme.colors.title).to(equal(UIColor(rgbao: "#111111")))
                    expect(uTheme.colors.accent).to(equal(UIColor(rgbao: "#222222")))
                    expect(uTheme.colors.text).to(equal(UIColor(rgbao: "#333333")))
                    expect(uTheme.colors.error).to(equal(UIColor(rgbao: "#444444")))
                    expect(uTheme.colors.background).to(equal(UIColor(rgbao: "#555555")))
                    expect(uTheme.colors.textOnAccent).to(equal(UIColor(rgbao: "#666666")))
                }
                it("should assign background color to cardColor") {
                    expect(uTheme.colors.cardColor).to(equal(uTheme.colors.background))
                }
            }

            context("When parsing theme colors from NEW json with card design color") {
                // Arrange
                var uTheme = UsabillaTheme()
                let colorsJson = UBMock.json("ThemeJsonWithCardColor")?["colors"]
                uTheme.updateColors(json: colorsJson!)

                it("should parse the correct colors") {
                    expect(uTheme.colors.title).to(equal(UIColor(rgbao: "#111111")))
                    expect(uTheme.colors.accent).to(equal(UIColor(rgbao: "#222222")))
                    expect(uTheme.colors.text).to(equal(UIColor(rgbao: "#333333")))
                    expect(uTheme.colors.error).to(equal(UIColor(rgbao: "#444444")))
                    expect(uTheme.colors.background).to(equal(UIColor(rgbao: "#555555")))
                    expect(uTheme.colors.textOnAccent).to(equal(UIColor(rgbao: "#666666")))
                    expect(uTheme.colors.cardColor).to(equal(UIColor(rgbao: "#777777")))
                }
            }
        }
    }
}
