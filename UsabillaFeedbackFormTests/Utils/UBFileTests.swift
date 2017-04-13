//
//  UBFileTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBFileTests: QuickSpec {

    override func spec() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootUrl = documentsDirectory.appendingPathComponent(kSDKRootDirectoryName)
        let directoryUrl = rootUrl.appendingPathComponent("testdirectory")

        describe("UBFileStorageDAOTests") {
            beforeEach {
                try? FileManager.default.removeItem(at: directoryUrl)
                let exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                expect(exist).to(beFalse())
            }
            context("When creating directory") {
                it("should succeed") {
                    let isCreated = UBFile.createDirectory(url: directoryUrl)
                    expect(isCreated).to(beTrue())
                    let exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beTrue())
                }

                it("should failed when using a wrong url") {
                    let isCreated = UBFile.createDirectory(url: URL(fileURLWithPath: "/temp"))
                    expect(isCreated).to(beFalse())
                }
            }

            context("When deleting directory") {
                it("should succeed") {
                    // create the directory
                    let isCreated = UBFile.createDirectory(url: directoryUrl)
                    expect(isCreated).to(beTrue())
                    var exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beTrue())

                    // delete the directory
                    let isDeleted = UBFile.deleteDirectory(url: directoryUrl)
                    expect(isDeleted).to(beTrue())
                    exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beFalse())
                }

                it("should failed when using a wrong url") {
                    let isCreated = UBFile.deleteDirectory(url: URL(fileURLWithPath: "/.../temp"))
                    expect(isCreated).to(beFalse())
                }
            }

            context("When listing content of directory") {
                it("should list the right items") {
                    // create the directory
                    let isCreated = UBFile.createDirectory(url: directoryUrl)
                    expect(isCreated).to(beTrue())
                    let exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beTrue())

                    expect(UBFile.nameOfFilesIn(directory: directoryUrl).count).to(equal(0))

                    // add files to the directory
                    let fileUrl = directoryUrl.appendingPathComponent("testid")
                    NSKeyedArchiver.archiveRootObject("helo", toFile: fileUrl.path)

                    let names = UBFile.nameOfFilesIn(directory: directoryUrl)
                    expect(names.count).to(equal(1))
                    expect(names.first!).to(equal("testid"))

                    // delete the directory
                    let isDeleted = UBFile.deleteDirectory(url: directoryUrl)
                    expect(isDeleted).to(beTrue())
                    expect(UBFile.nameOfFilesIn(directory: directoryUrl).count).to(equal(0))
                }
            }
        }
    }
}
