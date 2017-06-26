//
//  StringTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class StringTest: QuickSpec {

    override func spec() {

        describe("String divideInChunksOfSize") {
            let stringToChunk = "abcdefghilmnopqrst"

            it("should correctly divide by 3") {
                let stringChunks = stringToChunk.divideInChunksOfSize(3)
                expect(stringChunks.count).to(equal(6))
                expect(stringChunks[5].characters.count).to(equal(3))
                expect(stringChunks[0].characters.count).to(equal(3))
                expect(stringChunks[5]).to(equal("rst"))
                expect(stringChunks[0]).to(equal("abc"))
            }

            it("should correctly divide by 4") {
                let stringChunks = stringToChunk.divideInChunksOfSize(4)
                expect(stringChunks.count).to(equal(5))
                expect(stringChunks[4].characters.count).to(equal(2))
                expect(stringChunks[0].characters.count).to(equal(4))
                expect(stringChunks[4]).to(equal("st"))
                expect(stringChunks[0]).to(equal("abcd"))
            }

            it("should correctly divide by 5") {
                let stringChunks = stringToChunk.divideInChunksOfSize(5)
                expect(stringChunks.count).to(equal(4))
                expect(stringChunks[3].characters.count).to(equal(3))
                expect(stringChunks[0].characters.count).to(equal(5))
                expect(stringChunks[3]).to(equal("rst"))
                expect(stringChunks[0]).to(equal("abcde"))
            }
        }

        describe("String htmlToString") {
            it("htmlToAttributedString") {
                let htmlString = "Here is <i>some</i> <b>HTML</b>"
                let attributed = htmlString.parseHTMLString(font: UIFont.systemFont(ofSize: UIFont.systemFontSize))
                expect(attributed).toNot(beNil())
                expect(attributed.string).to(equal("Here is some HTML"))
            }
        }
    }
}
