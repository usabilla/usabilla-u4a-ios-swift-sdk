//
//  UBTelemetricResponse.swift
//  Usabilla
//
//  Created by Anders Liebl on 11/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit
enum DecodingError: Error {
    case corruptedData
}
// this needs to be handle - without over-engineering it 
enum UBTelemetricType {
    static func classFromString(_ name: ValueType, values: KeyedDecodingContainer<DynamicKey> ) -> UBTelemetricProtocol? {
        do {
            switch name.description {
            case TelemetryConstants.takeScreenshot:
                return try values.decodeIfPresent(UBTelemetricScreenshot.self, forKey: DynamicKey(stringValue: "a"))
            case TelemetryConstants.loadFeedbackForm:
                return try values.decodeIfPresent(UBTelemetricLoadForm.self, forKey: DynamicKey(stringValue: "a"))
            case TelemetryConstants.initialize:
                return try values.decodeIfPresent(UBTelemetricInitMethod.self, forKey: DynamicKey(stringValue: "a"))
            case TelemetryConstants.sendEvent:
                return try values.decodeIfPresent(UBTelemetricSendEvent.self, forKey: DynamicKey(stringValue: "a"))
            case TelemetryConstants.resetCampaignData:
                return try values.decodeIfPresent(UBTelemetricReset.self, forKey: DynamicKey(stringValue: "a"))
            case TelemetryConstants.removeCachedForms:
                return try values.decodeIfPresent(UBTelemetricRemoveCache.self, forKey: DynamicKey(stringValue: "a"))
            case TelemetryConstants.setDataMasking:
                return try values.decodeIfPresent(UBTelemetricSetDataMasking.self, forKey: DynamicKey(stringValue: "a"))
            case TelemetryConstants.dismiss:
                return try values.decodeIfPresent(UBTelemetricDismiss.self, forKey: DynamicKey(stringValue: "a"))
            case TelemetryConstants.debugEnabled:
                return try values.decodeIfPresent(UBTelemetricDebug.self, forKey: DynamicKey(stringValue: "a"))
            case TelemetryConstants.setFooterLogoClickable:
                return try values.decodeIfPresent(UBTelemetricSetFooterLogoClickable.self, forKey: DynamicKey(stringValue: "a"))
            default:
                return nil
            }
        } catch {
            return nil
        }
    }

    static func nameFromClass(_ type: Any) -> String {
        switch type {
        case is UBTelemetricScreenshot.Type:
            return TelemetryConstants.takeScreenshot
        case is UBTelemetricLoadForm.Type:
            return TelemetryConstants.loadFeedbackForm
        case is UBTelemetricInitMethod.Type:
            return TelemetryConstants.initialize
        case is UBTelemetricSendEvent.Type:
            return TelemetryConstants.sendEvent
        case is UBTelemetricReset.Type:
            return TelemetryConstants.resetCampaignData
        case is UBTelemetricRemoveCache.Type:
            return TelemetryConstants.removeCachedForms
        case is UBTelemetricSetDataMasking.Type:
            return TelemetryConstants.setDataMasking
        case is UBTelemetricDismiss.Type:
            return TelemetryConstants.dismiss
        case is UBTelemetricDebug.Type:
            return TelemetryConstants.debugEnabled
        case is UBTelemetricSetFooterLogoClickable:
            return TelemetryConstants.setFooterLogoClickable
        default:
            return TelemetryConstants.unknown
        }
    }
}

enum ValueType: Decodable {
    case number(Int)
    case longNumber(Double)
    case string(String)
    case boolean(Bool)
    case array([String])

    init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        do {
            let data = try singleValueContainer.decode(Int.self)
            self = .number(data)
            return
        } catch {}
        do {
            let data = try singleValueContainer.decode(String.self)
            self = .string(data)
            return
        } catch {}
        do {
            let data = try singleValueContainer.decode(Bool.self)
            self = .boolean(data)
            return
        } catch {}
        do {
            let data = try singleValueContainer.decode([String].self)
            self = .array(data)
            return
        } catch {}
        do {
            let data = try singleValueContainer.decode(Double.self)
            self = .longNumber(data)
            return
        } catch {}

        throw DecodingError.corruptedData
    }
    var description: String {
        switch self {
        case let .string(data):
            return data
        case let .number(data):
            return "\(data)"
        case let .longNumber(data):
            return "\(data)"
        case let .boolean(data):
            return "\(data)"
        case let .array(data):
            return "\(data.enumerated())"

        }
    }
}

typealias Values = [String: ValueType]

// When encodeing we want the name of the class to be used as key
// Since the data classes are a protocol, we need to create a Codingkey at runtime
// By using this, we can translate the class name to a Codingkey
struct DynamicKey: CodingKey {
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }

    var stringValue: String
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    init(className: AnyClass) {
        self.stringValue = String(describing: className)
    }
}

class UBTelemetricResponseLogs: Codable {
    var id: String
    var timestamp: String
    var orig: String?
    var dataLogs: [UBTelemetricProtocol] = []
    init(originClass: String? = nil) {
        id = String(describing: abs(NSUUID().hashValue))
        timestamp = Date().toRFC3339Format()
        orig = self.getCallingClass()
    }

    // get the classname of the class before the UsabillaInternal.
    // It's used to dertermine if the sdk was called from our bridge
    private func getCallingClass() -> String {
        let data = Thread.callStackSymbols
        var className: String {
            switch data {
            case _ where (data.first(where: {$0.contains("GetfeedbackCapacitor")}) != nil) :
                return "Capacitor"
            case _ where (data.first(where: {$0.contains("SwiftFlutterUsabillaPlugin")}) != nil) :
                return "Flutter"
            case _ where (data.first(where: {$0.contains("UsabillaBridge")}) != nil) :
                return "ReactNative"
            case _ where (data.first(where: {$0.contains("UsabillaB0")}) != nil) :
                return "Cordova"
            case _ where (data.first(where: {$0.contains("UsabillaInternal")}) != nil) :
                return "Internal"
            case _ where (data.first(where: {$0.contains("UsabillaXamarin")}) != nil) :
                return "Xamarin"
            case _ where (data.first(where: {$0.contains("UnityFramework")}) != nil) :
                return "Unity"
            default:
                return "Usabilla"
            }
        }
        return className
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        try container.encode(timestamp, forKey: DynamicKey(stringValue: "t"))
        try container.encode(id, forKey: DynamicKey(stringValue: "id"))
        try container.encodeIfPresent(orig, forKey: DynamicKey(stringValue: "orig"))

        try dataLogs.forEach {
            let dataEncoder = container.superEncoder(forKey: DynamicKey(stringValue: "a"))
            try $0.encode( to: dataEncoder)
        }
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DynamicKey.self)
        id = try values.decode(String.self, forKey: DynamicKey(stringValue: "id"))
        orig = try values.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: "orig"))
        timestamp  = try values.decode(String.self, forKey: DynamicKey(stringValue: "t"))

        dataLogs = []

        if let object = try values.decodeIfPresent(Values.self, forKey: DynamicKey(stringValue: "a")) {
            if let name = object["name"] {
                if let object = UBTelemetricType.classFromString(name, values: values) {
                    dataLogs.append(object)
               }
            }
        }
    }
}

class UBTelemetricResponse: Codable {
    let generalData: UBTelemetricGeneral
    var level: Int

    var logs: [UBTelemetricResponseLogs]

    init(_ loglevel: UBTelemetricLogLevel, data: UBTelemetricProtocol) {
        generalData = UBTelemetricGeneral()
        // this level is used to log data during the init process. Before data will be send, we check if we are
        // inside the server provided loglevel. If so, we submit.
        // By storing all data we ensure that its logged, even when the loglevel is not jet retrived from the server
        level = loglevel.rawValue
        logs = []
        let log = UBTelemetricResponseLogs()
        log.dataLogs.append(data)
        logs.append(log)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encode(generalData, forKey: DynamicKey(stringValue: "i"))
        try container.encodeIfPresent(level, forKey: DynamicKey(stringValue: "level"))
        try container.encode(logs, forKey: DynamicKey(stringValue: "logs"))
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DynamicKey.self)
        generalData = try values.decode(UBTelemetricGeneral.self, forKey: DynamicKey(stringValue: "i"))
        level  = try values.decode(Int.self, forKey: DynamicKey(stringValue: "level"))
        logs = []
        logs = try values.decode([UBTelemetricResponseLogs].self, forKey: DynamicKey(stringValue: "logs"))
    }
}

extension UBTelemetricResponse: CustomStringConvertible {
    var description: String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? jsonEncoder.encode(self),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
                return "JSON not availalbe"
        }
        return jsonString
    }
}

protocol UBTelemetricProtocol: Codable {

}

class UBTelemetricScreenshot: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricScreenshot.self)
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0
}

class UBTelemetricLoadForm: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricLoadForm.self)
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0
    var screenshot: Bool = false
    var theme: Bool = false
    var formId: String = ""
    var callback: Bool = false
    var displayed: Bool = false
    var formElements: Int = 0
}

class UBTelemetricInitMethod: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricInitMethod.self)
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0
    var appId: String = ""
    var numberCampaigns: Int = 0
}

class UBTelemetricSendEvent: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricSendEvent.self)
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0
    var event: String = ""
    var campaignTriggered: String?
    var displayed: Bool = false
}

class UBTelemetricReset: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricReset.self)
    var callback: Bool = false
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0

}

class UBTelemetricRemoveCache: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricRemoveCache.self)
    var removedCachedForms: Int = 0
    var callback: Bool = false
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0

}

class UBTelemetricDismiss: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricDebug.self)
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0
    var dismiss: String = ""
}

class UBTelemetricDebug: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricDebug.self)
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0
    var debug: Bool = false
}

class UBTelemetricSetDataMasking: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricSetDataMasking.self)
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0
    var masks: [String] = []
    var maskCharacter: String = ""

}

class UBTelemetricSetFooterLogoClickable: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricSetFooterLogoClickable.self)
    var errC: Int = 0
    var errM: String?
    var dur: Double = 0.0
    var footerClickable: Bool = true
}

class UBTelemetricGeneral: UBTelemetricProtocol {
    let appV: String
    let appN: String
    let device: String
    let osV: String
    let root: Bool
    let screen: String
    let sdkV: String
    let system: String
    let totMem: Double
    let totSp: Double

    init() {
        let uiDevice = UIDevice.current
        self.appV = Bundle.appVersion
        self.appN = Bundle.appName
        device = uiDevice.modelName
        osV = uiDevice.systemVersion
        root = DeviceInfo.isJailbroken()
        let screenBounds = UIScreen.main.bounds
        screen = "\(Int(screenBounds.width)) x \(Int(screenBounds.height))"
        self.sdkV = Bundle.sdkVersion
        system = "ios"
        totMem = Double(ProcessInfo.processInfo.physicalMemory / 1024)
        totSp = Double(DeviceInfo.DiskStatus.totalDiskSpaceInBytes / 1024)
    }
}
