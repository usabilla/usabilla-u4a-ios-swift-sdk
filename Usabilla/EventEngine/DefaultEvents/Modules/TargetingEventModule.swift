//
//  PercentageModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct TargetingEventModule: Codable, DefaultEventProtcol {
    var targetingName: String = DefaultEventModule.targeting.rawValue
    let moduleId: String
    let value: Double
    let comparison: ComparisonType
    var rule: RuleValue = .and

    init(value: Double, comparison: ComparisonType?, moduleId: String) {
        self.moduleId = moduleId
        self.value = value
        self.comparison = comparison ?? .gt
        self.targetingName = DefaultEventModule.targeting.rawValue
    }

    // swiftlint:disable cyclomatic_complexity
    func evaluate(_ object: EvaluationObject) -> Bool {
        guard let surveyId: String = object.get(key: .surveyId) else {
            return false
        }
        var moduleValue: Double = 0
        if  let aValue: String = object.get(key: .targetingProcentage) {
            moduleValue = Double(aValue) ?? 0
        } else {
            moduleValue = getCurrentPercentage(surveyId: surveyId, moduleId: moduleId)
        }

        if value == 100.0 {return true}
        if value == 0.0 {return false}
        var result = false

        switch comparison {
        case .lt:
            if moduleValue < value {
                result = true
            }
        case .lte:
            if moduleValue <= value {
                result = true
            }
        case .equal:
            if moduleValue == value {
                result = true
            }
        case .gt:
            if moduleValue > value {
                result = true
            }
        case .gte:
            if moduleValue >= value {
                result = true
            }
        case .neq:
            if moduleValue != value {
                result = true
            }
        }
        return result
   }
}

extension TargetingEventModule {
    func getCurrentPercentage(surveyId: String, moduleId: String) -> Double {
        let theIdentifier = createIdentifier(surveyId: surveyId, moduleId: moduleId)

        if let data = DefaultEventModuleDAO.shared.read(id: theIdentifier) {
            if let currentCounter = data.getValueForKey(.targeting) {
                return Double(currentCounter) ?? 100.0
            }
        }
        let diceRoll = Double.random(in: 1...100) + 1
        updateCurrentcount(surveyId: surveyId, moduleId: moduleId, currentCounter: diceRoll)
        DLogInfo("DefaultEvent calculated \(diceRoll)% as internal value")
        return diceRoll
    }

    func updateCurrentcount(surveyId: String, moduleId: String, currentCounter: Double) {
        var data = DefaultEventModuleState(moduleType: DefaultEventModule.targeting,
                                               surveyId: surveyId,
                                               moduleId: moduleId)
        data.setKeyValue(key: .targeting, value: String(currentCounter))
        DefaultEventModuleDAO.shared.storeModuleData(data: data)
    }

    private func createIdentifier(surveyId: String, moduleId: String) -> String {
        let theIdentifier = surveyId + "_" + moduleId
        return theIdentifier
    }
}
