//
//  EnablingEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 10/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation
struct EnablingEventModule: Codable, DefaultEventProtcol, DefaultEventResetProtocol {
    var enableEventName: String = DefaultEventModule.enable.rawValue
    let moduleId: String
    var showDate: Date?
    let comparison: ComparisonType
    var rule: RuleValue = .and

    init(comparison: ComparisonType?, moduleId: String) {
        self.comparison = comparison ?? .gte
        self.moduleId = moduleId
        enableEventName = DefaultEventModule.enable.rawValue
    }

    func evaluate (_ object: EvaluationObject) -> Bool {
        guard let surveyId: String = object.get(key: .surveyId) else {
            return false
        }
        if getLasteUsageDate(surveyId: surveyId) != nil {
            return false
        }
        return true
    }

    func getLasteUsageDate(surveyId: String) -> Date? {
        let theIdentifier = createIdentifier(surveyId: surveyId)

        if let data = DefaultEventModuleDAO.shared.read(id: theIdentifier) {
            if let lastDate = data.getValueForKey(.lastUsageDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .short
                let date = dateFormatter.date(from: lastDate)
                return date
            }
        }
        return nil
    }

    func setUsagedate(surveyId: String) -> Bool {
        var data = DefaultEventModuleState(moduleType: DefaultEventModule.occurrences,
                                               surveyId: surveyId,
                                               moduleId: moduleId)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        data.setKeyValue(key: .lastUsageDate, value: dateFormatter.string(from: date))
        DefaultEventModuleDAO.shared.storeModuleData(data: data)
        return true
    }

    // Remove the usage data for standard event if reactivation condition satisfy
    func reset(_ object: EvaluationObject) -> Bool {
        var reactivate: Bool = false
        guard let surveyId: String = object.get(key: .surveyId) else { return false }
        guard let lastShownDate = getLasteUsageDate(surveyId: surveyId) else { return false }
        guard let resetDuration: String = object.get(key: .resetDuration) else { return false }
        guard let currentReset = Int(resetDuration) else { return false }
        let lastShownTime = Date().getDateDiff(start: lastShownDate)
        if currentReset > 0 && lastShownTime >= currentReset {
            _ = removeUsageDate(surveyId: surveyId)
            reactivate = true
        }
        return reactivate
    }

    func removeUsageDate(surveyId: String) -> Bool {
        var data = DefaultEventModuleState(moduleType: DefaultEventModule.occurrences,
                                               surveyId: surveyId,
                                               moduleId: moduleId)
        data.setKeyValue(key: .lastUsageDate, value: "")
        DefaultEventModuleDAO.shared.storeModuleData(data: data)
        return true
    }

    private func createIdentifier(surveyId: String) -> String {
        let theIdentifier = surveyId + "_" + moduleId
        return theIdentifier
    }
}
