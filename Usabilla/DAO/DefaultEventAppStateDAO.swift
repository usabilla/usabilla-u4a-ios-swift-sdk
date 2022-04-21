//
//  DefaultEventAppStateDAO.swift
//  Usabilla
//
//  Created by Anders Liebl on 17/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

class DefaultEventAppStateDAO: FileStorageDAO<AppEventData> {
    static let directory = FileDirectory.defaultEventsModules
    static let shared = DefaultEventAppStateDAO()

    internal required init() {
        super.init(directory: DefaultEventAppStateDAO.directory)
    }

    override func id(forObj: AppEventData) -> String {
        return "AppStateID"
    }
}
