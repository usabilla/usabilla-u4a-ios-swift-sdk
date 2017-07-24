//
//  UBTestHelper.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 24/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//
import Foundation

@testable import UsabillaFeedbackForm

class UBTestHelper {
    class func getJSONFromFile(named name: String) -> JSON {
        let path = Bundle(for: UBTestHelper.self).path(forResource: name, ofType: "json")!
        let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
        return JSON(data: (data as Data?)!)
    }
}
