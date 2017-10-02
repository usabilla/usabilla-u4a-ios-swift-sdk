//
//  DateTests.swift
//  Usabilla
//
//  Created by Adil Bougamza on 02/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Usabilla

class DateTests: QuickSpec {

    override func spec() {

        describe("Date") {
            context("when toRFC3339Format is called") {
                it("should return right format") {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    var date = dateFormatter.date(from: "10-02-2017 14:07")
                    expect(date!.toRFC3339Format()).to(equal("2017-10-02T14:07:00Z"))

                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
                    date = dateFormatter.date(from: "10/02/2017 10:57:12")
                    expect(date!.toRFC3339Format()).to(equal("2017-10-02T10:57:12Z"))
                }
            }
        }
    }
}
