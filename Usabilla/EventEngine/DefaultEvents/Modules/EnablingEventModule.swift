//
//  EnablingEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 10/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation
struct EnablingEventModule: Codable, DefaultEventProtcol {
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

    private func createIdentifier(surveyId: String) -> String {
        let theIdentifier = surveyId + "_" + moduleId
        return theIdentifier
    }
}
