//
//  FirstLaunchEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct FirstLaunchEventModule: Codable, DefaultEventProtcol {
    var firstLaunchName = DefaultEventModule.firstLaunch.rawValue
    let moduleId: String
    let value: Bool
    var rule: RuleValue = .and

    init(value: Bool, moduleId: String) {
        self.value = value
        self.moduleId = moduleId
        firstLaunchName = DefaultEventModule.firstLaunch.rawValue
    }

    func evaluate (_ object: EvaluationObject) -> Bool {
      //  if value == false {return true}

        guard let surveyId: String = object.get(key: .surveyId) else {
            return false
        }
        let status =  getFirstLaunchStatus(surveyId: surveyId)
        // logic :
        // if firstLaunch is set to false, it must return false on first launch, true on consecutive
        // if firstLaunch is set to true, it must return true on first, false on consecutive

        switch value {
        case true:
            return !status
        case false:
            return status
        }
    }
}

extension FirstLaunchEventModule {
    func getFirstLaunchStatus(surveyId: String) -> Bool {
        if let data = DefaultEventModuleDAO.shared.read(id: createIdentifier(surveyId: surveyId)) {
            if let firstLaunch = data.getValueForKey(.firstlaunch) {
                return Bool(firstLaunch) ?? false
            }
        }
        _ = setFirstLaunch(surveyId: surveyId)
        return false
    }

    func setFirstLaunch(surveyId: String, firstLaunch: Bool = true) -> Bool {
        var data = DefaultEventModuleState(moduleType: DefaultEventModule.firstLaunch,
                                               surveyId: surveyId,
                                               moduleId: moduleId)
        data.setKeyValue(key: .firstlaunch, value: String(firstLaunch))
        DefaultEventModuleDAO.shared.storeModuleData(data: data)
        return true
    }

    private func createIdentifier(surveyId: String) -> String {
        let theIdentifier = surveyId + "_" + moduleId
        return theIdentifier
    }
}
