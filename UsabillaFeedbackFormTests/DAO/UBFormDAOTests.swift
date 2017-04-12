//
//  UBFormDAOTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 12/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBFormDAOTests: QuickSpec {

    override func spec() {

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryUrl = documentsDirectory.appendingPathComponent(UBFormDAO.directoryName)

        describe("UBFormDAOTests") {
            context("when directory is created") {
                it("should have created the directory") {
                    try? FileManager.default.removeItem(at: directoryUrl)
                    var exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beFalse())

                    UBFormDAO.shared.createDirectory(url: directoryUrl)

                    exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beTrue())
                }
            }

            context("when requesting an id") {
                it("should return the correct id") {
                    let form = UBMock.formMock()
                    let id = UBFormDAO.shared.id(forObj: form)
                    expect(id).to(equal(form.appId))
                }
            }

        }
    }
}
