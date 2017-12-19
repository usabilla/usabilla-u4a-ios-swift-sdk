//
//  PageModelTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 01/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class PageModelTests: QuickSpec {
    override func spec() {
        var pageModel: PageModel!
        describe("PageModelTests") {
            beforeEach {
                pageModel = UBMock.formMock().pages.first
            }

            context("When creating a page") {
                it("should have the right values") {
                    let page = PageModel(pageName: "test", type: .form)
                    expect(page.pageName).to(equal("test"))
                    expect(page.type).to(equal(PageType.form))
                }
            }

            context("When exporting to dictionary") {
                it("should export the right fields when no value are set") {
                    let dictionary = pageModel.toDictionary()

                    expect(dictionary.keys.count).to(equal(4))
                    expect(dictionary.keys.contains("mood")).to(beTrue())
                    expect(dictionary.keys.contains("nps")).to(beTrue())
                    expect(dictionary.keys.contains("Checkboxah")).to(beTrue())
                    expect(dictionary.keys.contains("text")).to(beTrue())
                    expect(dictionary["mood"]!).to(beNil())
                    expect(dictionary["nps"]!).to(beNil())
                    expect(dictionary["Checkboxah"]!).to(beNil())
                    expect(dictionary["text"]!).to(beNil())
                }

                it("should export the right values") {
                    let mood = pageModel.fields.first { $0 is MoodFieldModel } as? MoodFieldModel
                    mood?.fieldValue = 2

                    let dictionary = pageModel.toDictionary()
                    
                    expect(dictionary.keys.count).to(equal(4))
                    expect(dictionary.keys.contains("mood")).to(beTrue())
                    let value = dictionary["mood"] as! Int
                    expect(value).to(equal(2))
                }

                it("should not export fields that are not exportable") {
                    let pageModel = UBMock.formMock().pages[2]
                    expect(pageModel.fields.count).to(equal(2))

                    let paragraph = pageModel.fields.first { $0 is ParagraphFieldModel } as? ParagraphFieldModel
                    expect(paragraph?.fieldValue).to(equal("Click to edit paragraph"))

                    let dictionary = pageModel.toDictionary()
                    
                    expect(dictionary.keys.count).to(equal(1))
                    expect(dictionary.keys.contains("rating1")).to(beTrue())
                }
            }
        }
    }
}
