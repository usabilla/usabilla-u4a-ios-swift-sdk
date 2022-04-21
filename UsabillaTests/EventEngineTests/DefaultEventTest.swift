//
//  DefaultEventTest.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 03/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest

@testable import Usabilla

class DefaultEventTest: XCTestCase {
    var defaultEvent: DefaultEvent?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let path = Bundle(for:DefaultEventTest.self).path(forResource: "Default_event", ofType: "json")!
        let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonObj = JSON(data: (data as Data?)!)
        let defaultjons: JSON = jsonObj["default_events"]
        let modules: [JSON] = defaultjons["modules"].arrayValue
        
        defaultEvent =  DefaultEvent(json: modules, targetingId: "34324234c5")

        //print(defaultEvent)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOrder() throws {
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        if let data = try? encoder.encode(defaultEvent) {
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            let newModules = try decoder.decode(DefaultEvent.self, from: data)
            print(newModules)
            
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func saveJSONDataToFile(json: Data, fileName: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        if let documentsURL = documentsURL {
            let fileURL = documentsURL.appendingPathComponent(fileName)

            do {
                try json.write(to: fileURL, options: .atomicWrite)
            } catch {
                print(error)
            }
        }
    }

}
