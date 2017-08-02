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

    init(name: String) {
        self.name = name
    }

    func toString() -> String {
        return name
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
            PLog("❌ impossible to decode LeafEvent")
            return nil
        }
        self.init(name: name)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
    }
}

func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.name == rhs.name
}

func != (lhs: Event, rhs: Event) -> Bool {
    return lhs.name != rhs.name
}
