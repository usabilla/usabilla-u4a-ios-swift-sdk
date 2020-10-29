//
//  UBTelemetricResponse.swift
//  Usabilla
//
//  Created by Anders Liebl on 11/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation

enum DecodingError: Error {
    case corruptedData
}

enum UBTelemetricType {
    static func classFromString(_ name: ValueType, values: KeyedDecodingContainer<DynamicKey> ) -> UBTelemetricProtocol? {
        do {
            switch name.description {
            case TelemetryConstants.takeScreenshot:
                return try values.decodeIfPresent(UBTelemetricScreenshot.self, forKey: DynamicKey(stringValue: "action"))
            case TelemetryConstants.loadFeedbackForm:
                return try values.decodeIfPresent(UBTelemetricLoadForm.self, forKey: DynamicKey(stringValue: "action"))
            case TelemetryConstants.initialize:
                return try values.decodeIfPresent(UBTelemetricInitMethod.self, forKey: DynamicKey(stringValue: "action"))
            case TelemetryConstants.sendEvent:
                return try values.decodeIfPresent(UBTelemetricSendEvent.self, forKey: DynamicKey(stringValue: "action"))
            case TelemetryConstants.resetCampaignData:
                return try values.decodeIfPresent(UBTelemetricReset.self, forKey: DynamicKey(stringValue: "action"))
            case TelemetryConstants.removeCachedForms:
                return try values.decodeIfPresent(UBTelemetricRemoveCache.self, forKey: DynamicKey(stringValue: "action"))
            case TelemetryConstants.setDataMasking:
                return try values.decodeIfPresent(UBTelemetricSetDataMasking.self, forKey: DynamicKey(stringValue: "action"))
            case TelemetryConstants.dismiss:
                return try values.decodeIfPresent(UBTelemetricDismiss.self, forKey: DynamicKey(stringValue: "action"))
            case TelemetryConstants.debugEnabled:
                return try values.decodeIfPresent(UBTelemetricDebug.self, forKey: DynamicKey(stringValue: "action"))
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
        case is UBTelemetricLoadForm:
            return TelemetryConstants.loadFeedbackForm
        case is UBTelemetricInitMethod.Type:
            return TelemetryConstants.initialize
        case is UBTelemetricSendEvent:
            return TelemetryConstants.sendEvent
        case is UBTelemetricReset:
            return TelemetryConstants.resetCampaignData
        case is UBTelemetricRemoveCache:
            return TelemetryConstants.removeCachedForms
        case is UBTelemetricSetDataMasking.Type:
            return TelemetryConstants.setDataMasking
        case is UBTelemetricDismiss:
            return TelemetryConstants.dismiss
        case is UBTelemetricDebug:
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

        throw DecodingError.corruptedData
    }
    var description: String {
        switch self {
        case let .string(data):
            return data
        case let .number(data):
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

class UBTelemetricResponse: Codable {
    let timestamp: String
    let id: String
    var level: Int
    var originClass: String?
    var data: [UBTelemetricProtocol]

    init(_ loglevel: UBTelemetricLogLevel) {
        timestamp = Date().toRFC3339Format()
        id = String(describing: abs(NSUUID().hashValue))
        // this level is used to log data during the init process. Before data will be send, we check if we are
        // inside the server provided loglevel. If so, we submit.
        // By storing all data we ensure that its logged, even when the loglevel is not jet retrived from the server
        level = loglevel.rawValue
        data = []
        data.append(UBTelemetricSDK())
    }

    enum CodingKeys: String, CodingKey {
        case timestamp
        case id
        case level
        case originFramework
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        try container.encode(timestamp, forKey: DynamicKey(stringValue: "timestamp"))
        try container.encode(id, forKey: DynamicKey(stringValue: "id"))
        try container.encode(level, forKey: DynamicKey(stringValue: "option"))
        try container.encodeIfPresent(originClass, forKey: DynamicKey(stringValue: "originClass"))

        try data.forEach {
            let dataEncoder = container.superEncoder(forKey: DynamicKey(stringValue: "action"))
            try $0.encode( to: dataEncoder)
        }
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DynamicKey.self)
        timestamp = try values.decode(String.self, forKey: DynamicKey(stringValue: "timestamp"))
        id  = try values.decode(String.self, forKey: DynamicKey(stringValue: "id"))
        level = try values.decode(Int.self, forKey: DynamicKey(stringValue: "option"))
        originClass = try values.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: "originClass"))
        data = []
        if let object = try values.decodeIfPresent(UBTelemetricSDK.self, forKey: DynamicKey(stringValue: "metadata")) {
            data.append(object)
        }
        if let object = try values.decodeIfPresent(Values.self, forKey: DynamicKey(stringValue: "action")) {
            if let name = object["name"] {
                if let object = UBTelemetricType.classFromString(name, values: values) {
                    data.append(object)
                }
            }
        }
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
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0
}

class UBTelemetricLoadForm: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricLoadForm.self)
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0
    var screenshot: Bool = false
    var theme: Bool = false
    var formId: String = ""
    var callback: Bool = false
    var displayed: Bool = false
    var formElements: Int = 0
}

class UBTelemetricInitMethod: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricInitMethod.self)
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0
    var appId: String = ""
    var numberCampaigns: Int = 0
}

class UBTelemetricSendEvent: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricSendEvent.self)
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0
    var event: String = ""
    var campaignTriggered: String?
    var displayed: Bool = false
}

class UBTelemetricReset: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricReset.self)
    var callback: Bool = false
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0

}

class UBTelemetricRemoveCache: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricRemoveCache.self)
    var removedCachedForms: Int = 0
    var callback: Bool = false
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0

}

class UBTelemetricDismiss: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricDebug.self)
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0
    var dismiss: String = ""
}

class UBTelemetricDebug: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricDebug.self)
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0
    var debug: Bool = false
}

class UBTelemetricSetDataMasking: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricSetDataMasking.self)
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0
    var masks: [String] = []
    var maskCharacter: String = ""

}

class UBTelemetricSetFooterLogoClickable: UBTelemetricProtocol {
    var name: String = UBTelemetricType.nameFromClass(UBTelemetricSetFooterLogoClickable.self)
    var errorCode: Int = 0
    var errorMessage: String?
    var duration: Double = 0.0
    var setFooterLogoClickable: Bool = true
}
