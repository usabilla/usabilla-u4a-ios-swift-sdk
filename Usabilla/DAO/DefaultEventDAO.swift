//
//  DefaultEventDAO.swift
//  Usabilla
//
//  Created by Hitesh Jain on 25/04/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

class DefaultEventDAO: FileStorageDAO<DefaultEvent> {
    static let directory = FileDirectory.defaultEvents
    static let shared = DefaultEventDAO()

    internal required init() {
        super.init(directory: DefaultEventDAO.directory)
    }

    override func id(forObj: DefaultEvent) -> String {
        return forObj.targetingId
    }
}
