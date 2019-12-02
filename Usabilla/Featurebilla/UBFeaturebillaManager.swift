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
    // var percentage: Double {get set}
    // var sdkversion: String {get set}
}

private var featureSettings = [Setting]()

class UBFeaturebillaManager {
    private let featurebillaStore: FeaturebillaStoreProtocol
    private let featurebillaService: FeaturebillaServiceProtocol
    private let contextPercentage = "percentage"
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
            }
        }
    }

    func getSettingVariable(variableName: String, defaultValue: Any, userContexts: [String: String], completion:@escaping (_ value: Any?) -> Void ) {
        self.getSettingsList().then {_ in
            let result = featureSettings.filter {
                $0.variable == variableName && self.checkRules(setting: $0, userContexts: userContexts)
            }
            completion(result.first?.value ?? defaultValue)
        }
    }
    
    private func isPartOfPercentage(variableName: String, percentageValue: Double) -> Bool {
        if percentageValue == 0.0 {
            return false
        } else if percentageValue == 100.0 {
            return true
        } else {
            let computedPercentage = getComputedPercentage(variable: variableName)
            if computedPercentage <= percentageValue {
                    return false
            }
        }
        return false
    }

    func getSettingVariable(variableName: String, defaultValue: Any, userContexts: UBSettingProtocol, completion:@escaping (_ value: Any?) -> Void ) {
        self.getSettingsList().then {_ in
            let result = featureSettings.filter {
                $0.variable == variableName && self.checkRules(setting: $0, userContexts: userContexts)
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
