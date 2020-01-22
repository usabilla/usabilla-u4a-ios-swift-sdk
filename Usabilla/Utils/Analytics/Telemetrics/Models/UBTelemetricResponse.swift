//
//  UBTelemetricResponse.swift
//  Usabilla
//
//  Created by Anders Liebl on 11/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation

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
        try container.encode(level, forKey: DynamicKey(stringValue: "level"))
        try container.encodeIfPresent(originClass, forKey: DynamicKey(stringValue: "originClass"))

        try data.forEach {
            let nameOfClass = String(describing: $0)
            // use the classnames last part as codingkey
            // this is needed as the data holds protocols, that is not codeable at compiletime
            if let index = nameOfClass.lastIndex(of: ".") {
                let finalIndex = nameOfClass.index(index, offsetBy: 1)
                let str = String(nameOfClass[finalIndex...])
                let dataEncoder = container.superEncoder(forKey: DynamicKey(stringValue: str))
                try $0.encode( to: dataEncoder)
            }
        }
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DynamicKey.self)
        timestamp = try values.decode(String.self, forKey: DynamicKey(stringValue: "timestamp"))
        id  = try values.decode(String.self, forKey: DynamicKey(stringValue: "id"))
        level = try values.decode(Int.self, forKey: DynamicKey(stringValue: "level"))
        originClass = try values.decodeIfPresent(String.self, forKey: DynamicKey(stringValue: "originClass"))
        data = []
        if let object = try values.decodeIfPresent(UBTelemetricSDK.self, forKey: DynamicKey(className: UBTelemetricSDK.self)) {
            data.append(object)
        }
        if let object = try values.decodeIfPresent(UBTelemetricInitMethod.self, forKey: DynamicKey(className: UBTelemetricInitMethod.self)) {
            data.append(object)
        }
        if let object = try values.decodeIfPresent(UBTelemetricSendEvent.self, forKey: DynamicKey(className: UBTelemetricSendEvent.self)) {
            data.append(object)
        }
        if let object = try values.decodeIfPresent(UBTelemetricLoadForm.self, forKey: DynamicKey(className: UBTelemetricLoadForm.self)) {
            data.append(object)
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
class UBTelemetricInitMethod: UBTelemetricProtocol {
    var appId: String = ""
    var appIdCorrect: Bool = false
    var numberOfCampaigns: Int = 0
    var methodResult: Bool = true
    var methodMessage: String?
    var duration: Double = 0.0
}

class UBTelemetricSendEvent: UBTelemetricProtocol {
    var event: String = ""
    var campaignId: String?
    var displayed: Bool = false
    var methodResult: Bool = false
    var methodMessage: String?
    var duration: Double = 0.0
}

class UBTelemetricReset: UBTelemetricProtocol {
    var methodResult: Bool = false
    var methodMessage: String?
    var duration: Double = 0.0
}

class UBTelemetricLoadForm: UBTelemetricProtocol {
    let formID: String = ""
    let numberOfElements: Int = 0
    var displayed: Bool = false
    var methodResult: Bool = false
    var methodMessage: String?
    var duration: Double = 0.0
}
class UBTelemetricSetDataMasking: UBTelemetricProtocol {
    var masks: [String] = []
    var maskCharacter: String = ""
    var methodResult: Bool = false
    var methodMessage: String?
    var duration: Double = 0.0

}
