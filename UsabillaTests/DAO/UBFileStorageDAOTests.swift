//
//  UBFileStorageDAOTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 12/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

let kDirectoryName = FileDirectory.testDirectory

class UBFileStorageDAOTests: QuickSpec {
    class TestData: NSObject, NSCoding {
        static var decodingShouldFail = false
        static var decodingShouldReturnNil = false
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
            if TestData.decodingShouldFail {
                aDecoder.failWithError(NSError(domain: "", code: 0, userInfo: nil))
            }
            if TestData.decodingShouldReturnNil {
                return nil
            }
            id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
            name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        }
    }

    class TestDAO: UBFileStorageDAO<TestData> {

        static let shared = TestDAO()

        internal required init() {
            super.init(directoryName: FileDirectory.testDirectory)
        }

        override func id(forObj: TestData) -> String {
            return forObj.id
        }
    }

    override func spec() {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootUrl = documentsDirectory.appendingPathComponent(kSDKRootDirectoryName)
        let directoryUrl = rootUrl.appendingPathComponent(kDirectoryName.rawValue)

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
                UBFileHelper.createDirectory(url: directoryUrl)
                TestData.decodingShouldReturnNil = false
                TestData.decodingShouldFail = false
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

            context("When reading a data") {
                it("should return nil when unarchiving fails") {
                    let data = TestData(id: "testid", name: "testname")
                    let isCreated = TestDAO.shared.create(data)
                    expect(isCreated).to(beTrue())
                    var readValue = TestDAO.shared.read(id: "testid")
                    expect(readValue).toNot(beNil())
                    TestData.decodingShouldFail = true
                    readValue = TestDAO.shared.read(id: "testid")
                    expect(readValue).to(beNil())
                }

                it("should delete the data if the unarchiving fails") {
                    let data = TestData(id: "testid", name: "testname")
                    let isCreated = TestDAO.shared.create(data)
                    expect(isCreated).to(beTrue())

                    var readValue = TestDAO.shared.read(id: "testid")
                    expect(readValue).toNot(beNil())
                    expect(TestDAO.shared.readAll().count).to(equal(1))
                    TestData.decodingShouldFail = true
                    readValue = TestDAO.shared.read(id: "testid")
                    expect(readValue).to(beNil())
                    expect(TestDAO.shared.readAll().count).to(equal(0))
                }
                
                it("should delete the data if the unarchiving returns nil") {
                    let data = TestData(id: "testid", name: "testname")
                    let isCreated = TestDAO.shared.create(data)
                    expect(isCreated).to(beTrue())
                    
                    var readValue = TestDAO.shared.read(id: "testid")
                    expect(readValue).toNot(beNil())
                    expect(TestDAO.shared.readAll().count).to(equal(1))
                    TestData.decodingShouldReturnNil = true
                    readValue = TestDAO.shared.read(id: "testid")
                    expect(readValue).to(beNil())
                    expect(TestDAO.shared.readAll().count).to(equal(0))
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
