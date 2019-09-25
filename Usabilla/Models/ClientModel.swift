//
//  ClientModel.swift
//  Usabilla
//
//  Created by Hitesh Jain on 08/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation

class ClientModel {

    var behaviour: [String: Any] = [:]

    init() {
    }

    func addBehaviour(_ key: String, _ value: Any) {
        self.behaviour[key] = value
    }

    func toJson() -> [String: Any] {
        return ["behaviour": behaviour]
    }
}
