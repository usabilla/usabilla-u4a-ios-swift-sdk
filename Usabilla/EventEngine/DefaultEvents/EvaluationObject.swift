//
//  EvaluationObject.swift
//  Usabilla
//
//  Created by Anders Liebl on 09/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation
/*
 /// The EvaluationObject holds all datat each module could need to performa its task
 /// They are key-value pairs, and are definede in the EvaluationTypes
 
 
 */

enum EvaluationTypes: String, Codable {
    case eventType
    case launchTime
    case numberOfOccurense
    case firstLaunch
    case appVersion
    case osVersion
    case platform
    case timeSpent
    case timeUnit
    case eventOrderId
    case customerVariable
    case targetingProcentage
    case language
    case surveyId
    case currentTime
    case resetDuration // use for reactivation
}

struct EvaluationObject: Codable {
    private  var storrage: [EvaluationTypes: String] = [:]

    mutating func add(key: EvaluationTypes, value: String) {
        storrage[key] = value
    }

    mutating func addCustomerVariables(_ data: [String: String]) {
        var json = "{"
        for (aKey, aValue) in data {
            if json != "{" { json += ","}
            json += "\"\(aKey)\":\"\(aValue)\""
        }
        json += "}"
        storrage[.customerVariable] = json
    }

    mutating func addKeyValues(keyValues: [EvaluationTypes: String]) {
        for (aKey, aValue) in keyValues {
        storrage[aKey] = aValue
        }
    }
    func getCustomerVariables() -> [String: String] {
        if let data = storrage[.customerVariable]?.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: String] {
                    return json
                }
            } catch {
                return [:]
            }
        }
        return [:]
    }
    func get <T> (key: EvaluationTypes) -> T? {
        if let data = storrage[key] as? T {
            return data
        }
        return nil
    }
    func getKeyValues() -> [EvaluationTypes: String] {
        return storrage
    }
}
