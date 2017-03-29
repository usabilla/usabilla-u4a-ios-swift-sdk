//
//  Event.swift
//  EventEngine
///Users/Jack/Usabilla/iOS/EventEngine/EventEngine/Rules/Rule.swift
//  Created by Giacomo Pinato on 15/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding {

    let name: String
    let payload: [String: Any]?

    init(name: String) {
        self.name = name
        payload = nil
    }

    init(name: String, payload: [String: Any]?) {
        self.name = name
        self.payload = payload
    }

    func toString() -> String {
        return "\(name), \(payload)"
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let payload = aDecoder.decodeObject(forKey: "payload") as? [String: Any]?
        self.init(name: name!, payload: payload!)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.payload, forKey: "payload")

    }
}

func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.name == rhs.name
}

func != (lhs: Event, rhs: Event) -> Bool {
    return lhs.name != rhs.name
}
