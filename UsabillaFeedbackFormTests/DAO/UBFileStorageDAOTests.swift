//
//  UBFileStorageDAOTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 12/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import UsabillaFeedbackForm

let kDirectoryName = "testdata"

class UBFileStorageDAOTests: QuickSpec {
    class TestData: NSObject, NSCoding {
        var id: String
        var name: String

        init(id: String, name: String) {
            self.id = id
            self.name = name
        }

        func encode(with aCoder: NSCoder) {
            aCoder.encode(self.id, forKey: "id")
            aCoder.encode(self.name, forKey: "name")
        }

        required init?(coder aDecoder: NSCoder) {
            id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
            name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        }
    }

    class TestDAO: UBFileStorageDAO<TestData> {

        static let shared = TestDAO()

        internal required init() {
            super.init(directoryName: kDirectoryName)
        }

        override func id(forObj: TestData) -> String {
            return forObj.id
        }
    }

    override func spec() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootUrl = documentsDirectory.appendingPathComponent(kSDKRootDirectoryName)
        let directoryUrl = rootUrl.appendingPathComponent(kDirectoryName)

        describe("UBFileStorageDAOTests") {

            beforeSuite {
                try? FileManager.default.removeItem(at: directoryUrl)
                var exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                expect(exist).to(beFalse())

                _ = TestDAO.shared
                exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                expect(exist).to(beTrue())
            }

            beforeEach {
                // remove any previous dao directory
                try? FileManager.default.removeItem(at: directoryUrl)
                let exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                expect(exist).to(beFalse())
                UBFile.createDirectory(url: directoryUrl)
            }

            context("When creating directory") {
                it("should succeed") {
                    try? FileManager.default.removeItem(at: directoryUrl)
                    var exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beFalse())
                    let isCreated = UBFile.createDirectory(url: directoryUrl)
                    expect(isCreated).to(beTrue())
                    exist = FileManager.default.fileExists(atPath: directoryUrl.path)
                    expect(exist).to(beTrue())
                }

                it("should failed when using a wrong url") {
                    let isCreated = UBFile.createDirectory(url: URL(fileURLWithPath: "/temp"))
                    expect(isCreated).to(beFalse())
                }
            }

            context("When there is no data") {
                it("should have no data") {
                    expect(TestDAO.shared.readAll().count).to(equal(0))
                }

                it("should have no data with id") {
                    expect(TestDAO.shared.read(id: "blabla")).to(beNil())
                }
            }

            context("When creating a data") {
                it("should save it") {
                    let data = TestData(id: "testid", name: "testname")
                    let isCreated = TestDAO.shared.create(data)
                    expect(isCreated).to(beTrue())
                    let exist = FileManager.default.fileExists(atPath: directoryUrl.appendingPathComponent("testid").path)
                    expect(exist).to(beTrue())
                }
                it("should be able to read it") {
                    let data = TestData(id: "testid", name: "testname")
                    TestDAO.shared.create(data)
                    expect(TestDAO.shared.read(id: "testid")).toNot(beNil())
                    expect(TestDAO.shared.readAll().count).to(equal(1))
                    let data2 = TestData(id: "testid2", name: "testname2")
                    TestDAO.shared.create(data2)
                    expect(TestDAO.shared.readAll().count).to(equal(2))
                }
                it("should fail when id is wrong") {
                    let data = TestData(id: ".../..temp", name: "testname")
                    let isCreated = TestDAO.shared.create(data)
                    expect(isCreated).to(beFalse())
                }
            }

            context("When removing data") {
                it("should succeed when deleting one") {
                    // Create data
                    let data = TestData(id: "testid", name: "testname")
                    TestDAO.shared.create(data)

                    expect(TestDAO.shared.readAll().count).to(equal(1))

                    // Remove created data
                    let isDeleted = TestDAO.shared.delete(data)
                    expect(isDeleted).to(beTrue())
                    let exist = FileManager.default.fileExists(atPath: directoryUrl.appendingPathComponent("testid").path)
                    expect(exist).to(beFalse())
                    expect(TestDAO.shared.readAll().count).to(equal(0))
                }

                it("should succeed when deleting all") {
                    // Create data
                    let data = TestData(id: "testid", name: "testname")
                    let data2 = TestData(id: "testid2", name: "testname2")
                    TestDAO.shared.create(data)
                    TestDAO.shared.create(data2)

                    expect(TestDAO.shared.readAll().count).to(equal(2))

                    // Remove created data
                    let isDeleted = TestDAO.shared.deleteAll()

                    expect(isDeleted).to(beTrue())
                    var exist = FileManager.default.fileExists(atPath: directoryUrl.appendingPathComponent("testid").path)
                    expect(exist).to(beFalse())
                    exist = FileManager.default.fileExists(atPath: directoryUrl.appendingPathComponent("testid").path)
                    expect(exist).to(beFalse())

                    expect(TestDAO.shared.readAll().count).to(equal(0))
                }

                it("should fail when deleting one not exisiting") {
                    let data = TestData(id: "testid", name: "testname")
                    expect(TestDAO.shared.readAll().count).to(equal(0))
                    let isDeleted = TestDAO.shared.delete(data)
                    expect(isDeleted).to(beFalse())
                }

                it("should fail when deleting all") {
                    try? FileManager.default.removeItem(at: directoryUrl)
                    let isDeleted = TestDAO.shared.deleteAll()
                    expect(isDeleted).to(beFalse())
                }
            }
        }
    }
}
