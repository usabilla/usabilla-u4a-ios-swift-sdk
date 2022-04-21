//
//  DefaultEventStore.swift
//  Usabilla
//
//  Created by Hitesh Jain on 28/04/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

protocol DefaultEventStoreProtocol {
    func getDefaultEvents() -> [DefaultEvent]
}

class DefaultEventStore: DefaultEventStoreProtocol {
    func getDefaultEvents() -> [DefaultEvent] {
        // FIXME: remove error
        let defaultEvents = DefaultEventDAO.shared.readAll()
        return defaultEvents
    }
}
