//
//  DefaultEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 06/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

class DefaultEventModuleDAO: FileStorageDAO<DefaultEventModuleState> {
    static let directory = FileDirectory.defaultEventsModules
    static let shared = DefaultEventModuleDAO()

    internal required init() {
        super.init(directory: DefaultEventModuleDAO.directory)
    }

    override func id(forObj: DefaultEventModuleState) -> String {
        return forObj.surveyId + "_" + forObj.moduleId
    }

    func storeModuleData(data: DefaultEventModuleState) {
        create(data)
    }

    func getModuleData(identifier: String) -> DefaultEventModuleState? {
        read(id: identifier)
    }
}
