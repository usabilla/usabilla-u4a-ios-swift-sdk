//
//  UBFeedbackRequest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFeedbackRequest: NSObject, NSCoding {
    let id: String
    let payload: [String: Any]
    let screenshot: String?

    init(payload: [String: Any], screenshot: String?) {
        self.id = NSUUID().uuidString
        self.payload = payload
        self.screenshot = screenshot
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        self.id = (aDecoder.decodeObject(forKey: "id") as? String)!
        self.payload = (aDecoder.decodeObject(forKey: "payload") as? [String: Any])!
        self.screenshot = aDecoder.decodeObject(forKey: "screenshot") as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(payload, forKey: "payload")
        aCoder.encode(screenshot, forKey: "screnshot")
    }
}
