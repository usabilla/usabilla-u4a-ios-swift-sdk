//
//  PassiveStatus.swift
//  Usabilla
//
//  Created by Adil Bougamza on 08/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class PassiveStatus: NSObject, NSCoding {

    private struct Archiving {
        static let name = "name"
        static let value = "value"
    }

    enum PasstiveStatusType: String {
        case language
    }

    let name: PasstiveStatusType
    let value: String

    init(name: PasstiveStatusType, value: String) {
        self.name = name
        self.value = value
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Archiving.name) as? String,
            let nameType = PasstiveStatusType(rawValue: name),
            let value = aDecoder.decodeObject(forKey: Archiving.value) as? String else {
                PLog("❌ impossible to decode PassiveStatus")
                return nil
        }

        self.name = nameType
        self.value = value
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name.rawValue, forKey: Archiving.name)
        aCoder.encode(self.value, forKey: Archiving.value)
    }
}
