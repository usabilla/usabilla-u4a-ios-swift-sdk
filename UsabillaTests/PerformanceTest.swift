//
//  Performance.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 09/11/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla

class Performance: XCTestCase {

    var jsonObj: JSON!
    var base64image: String!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
        do {
            let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            jsonObj = JSON(data: data as Data)

        } catch let error as NSError {
            Swift.debugPrint(error.localizedDescription)
        }

        let image = UIImage(named: "a", in: Bundle(for: Performance.self), compatibleWith: nil)!
        let data = UIImageJPEGRepresentation(image, 0.5)
        base64image = data?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }

    func testChunkingPerformance() {
        // This is an example of a performance test case.
        self.measure {
            _ = self.base64image.components(withLength: 15000)
        }
    }

    func testJSONParserPerformance() {
        // This is an example of a performance test case.
        self.measure {
            _ = FormModel(json: self.jsonObj, id: "a", screenshot: nil)
        }
    }

    func testLoadingTime() {
        self.measure {
            var formModel: FormModel? = nil
            let path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
            do {
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: data as Data)
                formModel = FormModel(json: jsonObj, id: "a", screenshot: nil)
            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }

            let viewController = FormViewController(viewModel: UBFormViewModel(formModel: formModel!))
            viewController.loadView()
        }
    }
}
