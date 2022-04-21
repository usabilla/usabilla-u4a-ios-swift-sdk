//
//  UBFeaturebillaManager.swift
//  Usabilla
//
//  Created by Hitesh Jain on 12/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol UBSettingProtocol {
}

private var featureSettings = [Setting]()

// loglevels
struct UBTelemetricLogLevel: OptionSet {
    let rawValue: Int
    static let none = UBTelemetricLogLevel(rawValue: 0 << 0)
    static let methods = UBTelemetricLogLevel(rawValue: 1 << 0)
    static let properties = UBTelemetricLogLevel(rawValue: 1 << 1)
    static let networking = UBTelemetricLogLevel(rawValue: 1 << 2)
    static let memmory = UBTelemetricLogLevel(rawValue: 1 << 3)

    static let all: UBTelemetricLogLevel = [.methods, .properties, .networking, .memmory]
}

// The different Types of analytics that we support in FeatureBilla
enum FeatureTypes: String {
    case telemetryLevel
}

class UBFeaturebillaManager {
    private let featurebillaStore: FeaturebillaStoreProtocol
    private let featurebillaService: FeaturebillaServiceProtocol
    private let contextPercentage = "percentage"
    private var logLevels: [FeatureTypes: Any] = [:]

    init(featurebillaStore: FeaturebillaStoreProtocol, featurebillaService: FeaturebillaServiceProtocol) {
        self.featurebillaStore = featurebillaStore
        self.featurebillaService = featurebillaService
    }

    func getSettingsList() -> Promise<[Setting]> {
         return Promise { fulfill, reject in
            if featureSettings.isEmpty {
                self.featurebillaStore.loadSettings().then { settingModel in
                    featureSettings = settingModel.settings
                    fulfill(featureSettings)
                }.catch { error in
                    print("error \(error)")
                    reject(error)
                }
            } else {
                fulfill(featureSettings)
            }
        }
    }

    func getSettingVariable(variableName: FeatureTypes, defaultValue: Any, userContexts: [String: String], completion:@escaping (_ value: Any?) -> Void ) {
        self.getSettingsList().then {_ in
            let result = featureSettings.filter {
                $0.variable == variableName.rawValue && self.checkRules(setting: $0, userContexts: userContexts)
            }
            self.logLevels[variableName] = (result.first?.value ?? defaultValue)
            completion(result.first?.value ?? defaultValue)
        }
    }

    func shouldLog(_ type: FeatureTypes, logLevel: UBTelemetricLogLevel) -> Bool {
        if logLevels.isEmpty {  // data not loaded yet, fallback to default
            let  current: UBTelemetricLogLevel = [.methods, .properties, .all]
            return current.contains(logLevel)
        } else {
            if logLevel == .all {
                return true
            }
            if let feature = logLevels[type] as? String {
                let current = UBTelemetricLogLevel(rawValue: Int(feature) ?? 0)
                                let result = current.contains(logLevel)
                if !result {
                }
                return result
            }
            return false
        }
    }

    private func isPartOfPercentage(variableName: String, percentageValue: Double) -> Bool {
        if percentageValue == 0.0 {
            return false
        } else if percentageValue == 1.0 {
            return true
        } else {
            let computedPercentage = getComputedPercentage(variable: variableName)
            if computedPercentage <= percentageValue {
                return true
            }
        }
        return false
    }

    func getSettingVariable(variableName: FeatureTypes, defaultValue: Any, userContexts: UBSettingProtocol, completion:@escaping (_ value: Any?) -> Void ) {
        self.getSettingsList().then {_ in
            let result = featureSettings.filter {
                $0.variable == variableName.rawValue && self.checkRules(setting: $0, userContexts: userContexts)
            }
            completion(result.first?.value ?? defaultValue)
        }
    }

    private func checkRules(setting: Setting, userContexts: UBSettingProtocol) -> Bool {
        let selfMirror = Mirror(reflecting: self)
        for rules in setting.rules {
            if rules.name.lowercased() == contextPercentage {
                let percentageValue = Double(rules.value) ?? 1.0
                return isPartOfPercentage(variableName: setting.variable, percentageValue: percentageValue)
            } else if let value = selfMirror.descendant(rules.name.lowercased()) as? String {
                if value != rules.value {
                    return false
                }
            }
        }
        return true
    }

    private func checkRules(setting: Setting, userContexts: [String: String]) -> Bool {
        for rules in setting.rules {
            if rules.name.lowercased() == contextPercentage {
                let percentageValue = Double(rules.value) ?? 1.0
                return isPartOfPercentage(variableName: setting.variable, percentageValue: percentageValue)
            } else {
                if rules.value != userContexts[rules.name] {
                    return false
                }
            }
        }
        return true
    }

    private func getComputedPercentage(variable: String) -> Double {
        let percent: Double
        if let object = UserDefaults.standard.object(forKey: "com.usabilla.iosdk.\(variable).percentage") as? Double {
            percent = object
        } else {
            let device: String = UIDevice.current.identifierForVendor?.uuidString ?? "\(Date.timeIntervalSinceReferenceDate)"
            let val = (Double(abs((device + variable).hashValue) % 99) + 1) / 100
            UserDefaults.standard.set(val, forKey: "com.usabilla.iosdk.\(variable).percentage")
            percent = val
        }
        return percent
    }
}
