//
//  ActiveStatus.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 24/07/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class ActiveStatus: NSObject, NSCoding {

    let name: String
    let value: String

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    // MARK: NSCoding
    public required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let value = aDecoder.decodeObject(forKey: "value") as? String else {
                PLog("❌ impossible to decode ActiveStatus")
                return nil
        }

        self.name = name
        self.value = value
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.value, forKey: "value")
    }
}
