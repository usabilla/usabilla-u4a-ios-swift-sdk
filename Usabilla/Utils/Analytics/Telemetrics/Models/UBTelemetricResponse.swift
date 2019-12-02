//
//  UBTelemetricResponse.swift
//  Usabilla
//
//  Created by Anders Liebl on 11/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation

class UBTelemetricResponse: Codable {
    let timestamp: String
    let id: String
    var level: Int
    var originFramework: String?
    var methodData: UBTelemetricMethodData
    var initApp: UBTelemetricInitMethod
    var sdkData: UBTelemetricSDK
    var performance: [UBTelemetricPerformance] = []

    init(level: Int) {
        timestamp = Date().toRFC3339Format()
        id = String(describing: abs(NSUUID().hashValue))
        self.level = level
        methodData = UBTelemetricMethodData()
        initApp = UBTelemetricInitMethod()
        sdkData = UBTelemetricSDK()
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

class UBTelemetricMethodData: Codable {
    var methodName: String
    var methodResult: Bool
    var methodMessage: String
    var duration: Double
    private var numberOfCalls: Int

    init() {
        methodName =  ""
        methodResult = false
        duration = 0.0
        numberOfCalls = 1
        methodMessage = ""
    }
}

extension UBTelemetricMethodData {
    func addMethodCount() {
        self.numberOfCalls += 1
    }
}

struct UBTelemetricPerformance: Codable {
    let duration: Double
    let methodName: String
}

class UBTelemetricInitMethod: Codable {
    var appId: String = ""
    var appIdCorrect: Bool = false
    var numberOfCampaigns: Int = 0
}

struct UBTelemetricSendEvent: Codable {
    let event: String
    var campaignId: String
    var displayed: Bool
}

struct UBTelemetricLoadForm: Codable {
    let formID: String
    let numberOfElements: Int
}
