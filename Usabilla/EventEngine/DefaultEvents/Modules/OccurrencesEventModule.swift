//
//  OccurrencesEventModule.swift
//  Usabilla
//
//  Created by Anders Liebl on 02/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

struct OccurrencesEventModule: Codable, DefaultEventProtcol, DefaultEventResetProtocol {

    // Reset Current count for standard events and set it to 1.
    func reset(_ object: EvaluationObject) -> Bool {
        guard let surveyId: String = object.get(key: .surveyId) else {
            return false
        }
        updateCurrentcount(surveyId: surveyId, moduleId: moduleId, currentCounter: 1)
        return true
    }

    var occurrencesEventName: String = DefaultEventModule.occurrences.rawValue
    let moduleId: String
    let counter: Int
    let comparison: ComparisonType
    var rule: RuleValue = .and

    init( counter: Int, comparison: ComparisonType?, moduleId: String) {
        self.moduleId = moduleId
        self.counter = counter
        self.comparison = comparison ?? .gte
        occurrencesEventName = DefaultEventModule.occurrences.rawValue
    }

    // swiftlint:disable cyclomatic_complexity
    func evaluate (_ object: EvaluationObject) -> Bool {
        var result = false
        guard let surveyId: String = object.get(key: .surveyId) else {
            return false
        }
        let aCounter = getCurrentcount(surveyId: surveyId, moduleId: moduleId)
            switch comparison {
            case .lt:
                if aCounter < counter {
                    result = true
                }
            case .lte:
                if aCounter <= counter {
                    result = true
                }
            case .equal:
                if aCounter == counter {
                    result = true
                }
            case .gt:
                if aCounter > counter {
                    result = true
                }
            case .gte:
                if aCounter >= counter {
                    result = true
                }
            case .neq:
                if aCounter != counter {
                    result = true
                }
            }
        let newCounter = aCounter + 1
        updateCurrentcount(surveyId: surveyId, moduleId: moduleId, currentCounter: newCounter)
        return result
    }

    func getCurrentcount(surveyId: String, moduleId: String) -> Int {
        let theIdentifier = createIdentifier(surveyId: surveyId, moduleId: moduleId)

        if let data = DefaultEventModuleDAO.shared.read(id: theIdentifier) {
            if let currentCounter = data.getValueForKey(.occurrence) {
                return Int(currentCounter) ?? 1
            }
        }
        return 1
    }

    func updateCurrentcount(surveyId: String, moduleId: String, currentCounter: Int) {
        var data = DefaultEventModuleState(moduleType: DefaultEventModule.occurrences,
                                               surveyId: surveyId,
                                               moduleId: moduleId)
        data.setKeyValue(key: .occurrence, value: String(currentCounter))
        DefaultEventModuleDAO.shared.storeModuleData(data: data)
    }

    private func createIdentifier(surveyId: String, moduleId: String) -> String {
        let theIdentifier = surveyId + "_" + moduleId
        return theIdentifier
    }

}

extension OccurrencesEventModule {
    enum Error: Swift.Error {
            case fileAlreadyExists
            case invalidDirectory
            case writtingFailed
        }

    private func makeURL(forFileNamed fileName: String) -> URL? {
        let fileManager = FileManager.default
            guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            return url.appendingPathComponent(fileName)
        }

    func save(fileNamed: String, data: Data) throws {
            guard let url = makeURL(forFileNamed: fileNamed) else {
                throw Error.invalidDirectory
            }
            do {
                try data.write(to: url)
            } catch {
                debugPrint(error)
                throw Error.writtingFailed
            }
        }
}
