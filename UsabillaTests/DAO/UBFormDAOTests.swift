//
//  UBFormDAOTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 12/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UBFormDAOTests: QuickSpec {

    override func spec() {

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootUrl = documentsDirectory.appendingPathComponent("UBSDK")
        let directoryUrl = rootUrl.appendingPathComponent(UBFormDAO.directory.name)

        describe("UBFormDAOTests") {
            context("when directory is created") {
                it("should have created the directory") {
                    try? FileManager.default.removeItem(at: directoryUrl)
                    var exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beFalse())

                    UBFileHelper.createDirectory(url: directoryUrl)

                    exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beTrue())
                    expect(directoryUrl.lastPathComponent).to(equal("Forms"))
                }
            }

            context("when requesting an id") {
                it("should return the correct id") {
                    let form = UBMock.formMock()
                    let id = UBFormDAO.shared.id(forObj: form)
                    expect(id).to(equal(form.identifier))
                }
            }
        }
    }
}
