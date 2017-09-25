//
//  UIImageTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 25/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UIImageTest: QuickSpec {

    override func spec() {

        describe("UIImage") {
            let powered = Icons.imageOfPoweredBy(color: .blue)

            it("UIImage alpha") {
                _ = powered.alpha(value: 0.3)
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
            context("When encoding in base64") {
                it("Should encode correctly") {
                    let image = UIImage(named: "small-image", in: Bundle(for: UIImageTest.self), compatibleWith: nil)
                    let encoded = image!.toBase64()
                    expect(encoded).to(equal("/9j/4AAQSkZJRgABAQAASABIAAD/4QBYRXhpZgAATU0AKgAAAAgAAgESAAMAAAABAAEAAIdpAAQAAAABAAAAJgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAABaADAAQAAAABAAAABAAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/8AAEQgABAAFAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/bAEMABgYGBgYGCgYGCg4KCgoOEg4ODg4SFxISEhISFxwXFxcXFxccHBwcHBwcHCIiIiIiIicnJycnLCwsLCwsLCwsLP/bAEMBBwcHCwoLEwoKEy4fGh8uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLv/dAAQAAf/aAAwDAQACEQMRAD8A5TxP4z8UNqpitr6S2jjjQBIgoBJySTuDHP41z/8Awl/i7/oL3P8A45/8TUHiL/kMSf7kf8qxa1IP/9k="))
                }
            }
        }
    }
}
