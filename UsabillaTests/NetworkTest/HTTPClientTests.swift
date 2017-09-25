//
//  HTTPClientTests.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 22/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class HTTPClientTests: QuickSpec {

    override func spec() {

        let etag1: String? = nil
        let etag2: String? = nil
        let etag3: String? = "one"
        let etag4: String? = "two"

        describe("HTTPClient") {

            context("when comparing etags") {

                it("compares two nil etags correctly") {
                    expect(HTTPClient.hasChanged(oldEtag: etag1, newEtag: etag2)).to(beTrue())
                }

                it("compares a nil and a non nil etag correctly") {
                    expect(HTTPClient.hasChanged(oldEtag: etag1, newEtag: etag3)).to(beTrue())
                }

                it("compares two different non nil etags correctly") {
                    expect(HTTPClient.hasChanged(oldEtag: etag3, newEtag: etag4)).to(beTrue())
                }

                it("compares two equal non nil etags correctly") {
                    expect(HTTPClient.hasChanged(oldEtag: etag3, newEtag: etag3)).to(beFalse())
                }
            }
        }
    }
}
