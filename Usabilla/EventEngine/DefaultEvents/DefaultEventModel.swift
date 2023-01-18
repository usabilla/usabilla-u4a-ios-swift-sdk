//
//  DefaultEventModel.swift
//  Usabilla
//
//  Created by Anders Liebl on 20/04/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

private struct NoResultCodable: Codable {}

enum SurveyOriginType: String, Codable {
    case GFPCampaign
    case GFPForm
    case unknow
}

struct DefaultEvent: Codable {
    let modules: [DefaultEventProtcol]
    var surveyId: String = ""
    var surveyType: SurveyOriginType = .unknow
    var targetingId: String = ""
    var creationdate: Date = Date()
    var status: Bool = true
    var resetDuration: Int64 = 0 // use for reactivation
    init(json: [JSON], targetingId: String) {
        self.targetingId = targetingId
        var tempModules: [DefaultEventProtcol] = []
        var rownr = 0

        // When init from JSON, always set the first module to be an EnablingModule
        // must do some more check here
        let moduleId = targetingId + "_" + String(rownr)
        let module = EnablingEventModule(comparison: .equal, moduleId: moduleId)
        tempModules.append(module)
        rownr += 1

        json.forEach({
            let comparison = ComparisonType(rawValue: $0["comparison"].stringValue)
            let moduleId = targetingId + "_" + String(rownr)
            switch $0["type"].stringValue {

            case DefaultEventModule.system.rawValue:
                if let type = SystemEventType(rawValue: $0["value"].stringValue) {
                    let module = SystemEventModule(systemType: type)
                    tempModules.append(module)
                }
            case DefaultEventModule.platform.rawValue:
                let value = $0["value"].stringValue.lowercased()
                let module = PlatformEventModule(platform: value, comparison: comparison)
                tempModules.append(module)

            case DefaultEventModule.occurrences.rawValue :
                let value = $0["value"].intValue
                let module = OccurrencesEventModule(counter: value, comparison: comparison, moduleId: moduleId)
                tempModules.append(module)

            case DefaultEventModule.date.rawValue:
                let value = $0["value"].stringValue
                let module = DateEventModule(date: value, comparison: comparison)
                tempModules.append(module)

            case DefaultEventModule.time.rawValue:
                let value = $0["value"].stringValue
                let module = TimeEventModule(time: value, comparison: comparison)
                tempModules.append(module)

            case DefaultEventModule.appVersion.rawValue:
                let value = $0["value"].stringValue
                if let aPlatform = PlatformType(rawValue: $0["platform"].stringValue) {
                    // test here for the platformtypes that we dont want eg. andorid
                    if aPlatform == .android {return}
                }
                let module = AppVersionEventModule(version: value, comparison: comparison, platform: .ios)
                tempModules.append(module)

            case DefaultEventModule.osVersion.rawValue:
                let value = $0["value"].stringValue
                if let aPlatform = PlatformType(rawValue: $0["platform"].stringValue) {
                    // test here for the platformtypes that we dont want eg. andorid
                    if aPlatform == .android {return}
                }
                let module = OsVersionEventModule(version: value, comparison: comparison, platform: .ios)
                tempModules.append(module)

            case DefaultEventModule.firstLaunch.rawValue:
                let value = $0["value"].boolValue
                let module = FirstLaunchEventModule(value: value, moduleId: moduleId)
                tempModules.append(module)

            case DefaultEventModule.timeSpent.rawValue:
                let value = $0["value"].stringValue
                let unit = TimeUnit(rawValue: $0["unit"].stringValue) ?? .seconds
                let module = TimeSpentEventModule(value: value, comparison: comparison, timeUnit: unit)
                tempModules.append(module)

            case DefaultEventModule.customVariable.rawValue:
                let key = $0["key"].stringValue
                let value = $0["value"].stringValue
                let module = CustomerVariableModule(key: key, value: value, comparison: comparison)
                tempModules.append(module)

            case DefaultEventModule.targeting.rawValue:
                let value = $0["value"].doubleValue
                let module = TargetingEventModule(value: value, comparison: comparison, moduleId: moduleId)
                tempModules.append(module)

            case DefaultEventModule.userLanguage.rawValue:
                let value = $0["value"].stringValue
                let module = UserLanguageModule(value: value, comparison: comparison)
                tempModules.append(module)

            case DefaultEventModule.enable.rawValue :
                let moduleId = targetingId + "_" + String(rownr)
                let module = EnablingEventModule(comparison: .equal, moduleId: moduleId)
                tempModules.append(module)

            default :
                Swift.debugPrint("none found for type: '\($0["type"].stringValue)'")
            }
            rownr += 1
        })
        modules = tempModules
    }
    enum ModuleTypeKey: CodingKey {
            case type
        }

    enum CodingKeys: String, CodingKey {
            case modules
            case campaignId
            case targetingId
            case surveyType
            case creationDate
            case status
            case resetDuration
        }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var modulesArray = try container.nestedUnkeyedContainer(forKey: .modules)
        var tempModule: [DefaultEventProtcol] = []

        while !modulesArray.isAtEnd {
           // let obj = try modulesArray.decode(
            if let object = try? modulesArray.decode(SystemEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(PlatformEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(OccurrencesEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(DateEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(TimeEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(AppVersionEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(OsVersionEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(FirstLaunchEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(TimeSpentEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(CustomerVariableModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(TargetingEventModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(UserLanguageModule.self) {
                tempModule.append(object)
            } else if let object = try? modulesArray.decode(EnablingEventModule.self) {
                tempModule.append(object)
            } else {
                _ = try? modulesArray.decode(NoResultCodable.self)
            }
        }
        modules = tempModule
        if let aValue = try container.decodeIfPresent(String.self, forKey: .campaignId) {
            surveyId = aValue
        } else {
            surveyId = ""
        }

        if let aValue = try container.decodeIfPresent(String.self, forKey: .surveyType) {
            surveyType = SurveyOriginType(rawValue: aValue) ?? .unknow
        } else {
            surveyType = .unknow
        }

        if let aValue = try container.decodeIfPresent(String.self, forKey: .targetingId) {
            targetingId = aValue
        } else {
            targetingId = ""
        }

        if let aValue = try container.decodeIfPresent(Date.self, forKey: .creationDate) {
            creationdate = aValue
        } else {
            creationdate = Date()
        }
        if let aValue = try container.decodeIfPresent(Bool.self, forKey: .status) {
            status = aValue
        } else {
            status = true
        }
        if let aValue = try container.decodeIfPresent(Int64.self, forKey: .resetDuration) {
            resetDuration = aValue
        } else {
            resetDuration = 0
        }

    }
    // swiftlint:disable cyclomatic_complexity
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(surveyId, forKey: .campaignId)
        try container.encode(targetingId, forKey: .targetingId)
        try container.encode(surveyType, forKey: .surveyType)
        try container.encode(creationdate, forKey: .creationDate)
        try container.encode(status, forKey: .status)
        try container.encode(resetDuration, forKey: .resetDuration)

        var nestedContainer = container.nestedUnkeyedContainer(forKey: .modules)

        try modules.forEach { object in
            switch object {
            case is SystemEventModule:
                if let module = object as? SystemEventModule {
                    try nestedContainer.encode(module)
                }
            case is PlatformEventModule:
                if let module = object as? PlatformEventModule {
                    try nestedContainer.encode(module)
                }
            case is OccurrencesEventModule:
                if let module = object as? OccurrencesEventModule {
                    try nestedContainer.encode(module)
                }
            case is DateEventModule:
                if let module = object as? DateEventModule {
                    try nestedContainer.encode(module)
                }
            case is TimeEventModule:
                if let module = object as? TimeEventModule {
                    try nestedContainer.encode(module)
                }
            case is AppVersionEventModule:
                if let module = object as? AppVersionEventModule {
                    try nestedContainer.encode(module)
                }
            case is OsVersionEventModule:
                if let module = object as? OsVersionEventModule {
                    try nestedContainer.encode(module)
                }
            case is FirstLaunchEventModule:
                if let module = object as? FirstLaunchEventModule {
                    try nestedContainer.encode(module)
                }
            case is TimeSpentEventModule:
                if let module = object as? TimeSpentEventModule {
                    try nestedContainer.encode(module)
                }
            case is CustomerVariableModule:
                if let module = object as? CustomerVariableModule {
                    try nestedContainer.encode(module)
                }
            case is TargetingEventModule:
                if let module = object as? TargetingEventModule {
                    try nestedContainer.encode(module)
                }
            case is UserLanguageModule:
                if let module = object as? UserLanguageModule {
                    try nestedContainer.encode(module)
                }
            case is EnablingEventModule:
                if let module = object as? EnablingEventModule {
                    try nestedContainer.encode(module)
                }
            default:
                print("Noting to decode for \(object)")
            }
        }
    }
}

enum ModuleStateType: String, Codable {
    case occurrence
    case firstlaunch
    case lastUsageDate
    case targeting
}

struct DefaultEventModuleState: Codable {
    var moduleType: DefaultEventModule
    var surveyId: String
    var moduleId: String
    private var data: [String: String] = [:]

    init(moduleType: DefaultEventModule, surveyId: String, moduleId: String) {
        self.moduleType = moduleType
        self.surveyId = surveyId
        self.moduleId = moduleId
    }

    mutating func setKeyValue(key: ModuleStateType, value: String) {
        data[key.rawValue] = value
    }
    func getValueForKey(_ key: ModuleStateType) -> String? {
        return data[key.rawValue]
    }

}

enum DefaultEventModule: String, Codable, CodingKey {
    case system
    case platform
    case occurrences
    case date
    case time
    case appVersion
    case osVersion
    case firstLaunch
    case timeSpent
    case customVariable
    case targeting
    case userLanguage
    case timeUnit
    case enable
}

enum SystemEventType: String, Codable {
    case launch
    case exit
    case crash
    case unknow
}

enum PlatformType: String, Codable {
    case android
    case ios
    case all
}
// swiftlint:disable identifier_name
enum ComparisonType: String, Codable {
    case lt
    case lte
    case equal
    case gt
    case gte
    case neq
}
// swiftlint:disable identifier_name
enum RuleValue: String, Codable {
    case and
    case or
}

enum TimeUnit: String, Codable {
    case seconds
    case minutes
    case hours
    case days
    case weeks
    case months
    case year
}

protocol DefaultEventProtcol: Codable {
    func evaluate (_ object: EvaluationObject) -> Bool
    init(from decoder: Decoder) throws
}

protocol DefaultEventResetProtocol: Codable {
    func reset (_ object: EvaluationObject) -> Bool
}
