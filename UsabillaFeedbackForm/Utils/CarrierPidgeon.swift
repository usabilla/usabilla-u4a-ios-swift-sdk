//
//  CarrierPidgeon.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 17/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class CarrierPidgeon {

    let fieldID: String
    let fieldValue: [String]


    init(fieldID: String, fieldValue: String) {
        self.fieldID = fieldID
        self.fieldValue = [fieldValue]
    }

    init(fieldID: String, fieldValue: [String]) {
        self.fieldID = fieldID
        self.fieldValue = fieldValue
    }

}
