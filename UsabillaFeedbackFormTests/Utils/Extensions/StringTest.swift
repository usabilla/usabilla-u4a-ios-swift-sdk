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

        describe("String components withLength:") {
            let stringToChunk = "abcdefghilmnopqrst"

            it("should correctly divide by 3") {
                let stringChunks = stringToChunk.components(withLength: 3)
                expect(stringChunks.count).to(equal(6))
                expect(stringChunks[5].characters.count).to(equal(3))
                expect(stringChunks[0].characters.count).to(equal(3))
                expect(stringChunks[5]).to(equal("rst"))
                expect(stringChunks[0]).to(equal("abc"))
            }

            it("should correctly divide by 4") {
                let stringChunks = stringToChunk.components(withLength: 4)
                expect(stringChunks.count).to(equal(5))
                expect(stringChunks[4].characters.count).to(equal(2))
                expect(stringChunks[0].characters.count).to(equal(4))
                expect(stringChunks[4]).to(equal("st"))
                expect(stringChunks[0]).to(equal("abcd"))
            }

            it("should correctly divide by 5") {
                let stringChunks = stringToChunk.components(withLength: 5)
                expect(stringChunks.count).to(equal(4))
                expect(stringChunks[3].characters.count).to(equal(3))
                expect(stringChunks[0].characters.count).to(equal(5))
                expect(stringChunks[3]).to(equal("rst"))
                expect(stringChunks[0]).to(equal("abcde"))
            }

            it("should correctly divide by 5") {
                let stringChunks = stringToChunk.components(withLength: 5)
                expect(stringChunks.count).to(equal(4))
                expect(stringChunks[3].characters.count).to(equal(3))
                expect(stringChunks[0].characters.count).to(equal(5))
                expect(stringChunks[3]).to(equal("rst"))
                expect(stringChunks[0]).to(equal("abcde"))
            }

            context("When splitting chunk from a base64") {
                it ("should correctly split the string") {
                    let image = UIImage(named: "small-image", in: Bundle(for: UIImageTest.self), compatibleWith: nil)
                    let data = UIImageJPEGRepresentation(image!.fixSizeAndOrientation(), 0.5)
                    let encoded = data?.base64EncodedString()
                    let chunks = encoded!.components(withLength: 31250)
                    var reconstructed: String = ""
                    for chunk in chunks {
                        reconstructed = reconstructed.appending(chunk)
                    }
                }
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

        context("When converting to date") {
            it("should succeed") {
                var dateComponents = DateComponents()
                dateComponents.year = 2002
                dateComponents.month = 02
                dateComponents.day = 10
                dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
                dateComponents.hour = 15
                dateComponents.minute = 00
                let userCalendar = Calendar.current
                let someDateTime = userCalendar.date(from: dateComponents)
                
                expect(someDateTime).toNot(beNil())
                
                var date = "2002-10-02T10:00:00-05:00".dateFromRFC3339
                expect(date).toNot(beNil())
                
                date = "2002-10-02T15:00:00Z".dateFromRFC3339
                expect(date).toNot(beNil())
                
                date = "2002-10-02T15:00:00.955Z".dateFromRFC3339
                expect(date).toNot(beNil())
                expect(date?.description).to(equal("2002-10-02 15:00:00 +0000"))
            }

            it("should fail") {
                let date = "1980".dateFromRFC3339
                expect(date).to(beNil())
            }
        }
    }
}
