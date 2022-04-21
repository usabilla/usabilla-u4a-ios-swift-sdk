//
//  SystemEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct SystemEventModule: Codable, DefaultEventProtcol {
    var systemEventName: String = DefaultEventModule.system.rawValue
    var systemType: SystemEventType

    init( systemType: SystemEventType) {
        self.systemType = systemType
        systemEventName =  DefaultEventModule.system.rawValue
    }

    func evaluate (_ object: EvaluationObject) -> Bool {
        if let anObject: String = object.get(key: .eventType) {
            if systemType == SystemEventType(rawValue: anObject) {return true}
        }
        return false
    }
}
