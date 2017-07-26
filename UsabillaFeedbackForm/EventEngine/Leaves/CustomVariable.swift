//
//  CustomVariable.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 24/07/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CustomVaribale : AbstractRule {

    var type: RuleType
    let name: String
    let value: String

    init(name: String, value: String, type: RuleType) {
        self.name = name
        self.value = value
        self.type = type
    }

    convenience init?(json: JSON) {
        guard let name = json["name"].string, let value = json["value"].string else {
            return nil
        }

        self.init(name: name, value: value, type: RuleType.customeVariable)
    }
    
    // MARK: NSCoding
    
    public required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let value = aDecoder.decodeObject(forKey: "value") as? String,
            let typeString = aDecoder.decodeObject(forKey: "type") as? String,
            let type = RuleType(rawValue: typeString) else {
                PLog("❌ impossible to decode CustomVaribale")
                return nil
        }
        
        self.type = type
        self.name = name
        self.value = value
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.value, forKey: "value")
        aCoder.encode(self.type.rawValue, forKey: "type")
    }
}
