//
//  UBTelemetrics.swift
//  Usabilla
//
//  Created by Anders Liebl on 06/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class UBTelemetrics {

    private var startTime: [String: Date] = [:]
    private var log: [String: UBTelemetricResponse] = [:]
    private let maxnumberOfEntries = 10  // the max number of entries, 0 equals no limit
    private var telemtricService = TelemtryService()

    private var featureBillaService: UBFeaturebillaManager
    var submitTelemetryData = true
    init(manager: UBFeaturebillaManager) {
        self.featureBillaService = manager
        manager.getSettingVariable(variableName: .telemetryLevel, defaultValue: 0.5, userContexts: ["platform": "ios", "sdk": "6.4.3"], completion: {_ in
        })
    }
    /// Starts the logging (time) for an event. The returned id, must be use in  calls to alterData or logEnd. If nil is returned,
    /// when the log is started, its checked towards the percentage, and if inside the envelope,  all logging will occur. There is no
    /// test during alterData og logEnd.
    ///    - Parameter method: the method name to log must be lentgh > 0, else no loging will occur for the
    ///    - Parameter file: the file where the method to log is called from (defaults to empty string)
    ///    - Parameter line: the line number where the method to log is called from (defaults to 0)
    ///    - Parameter logLevel: the loglevel this log entry belongs to
    func logStart(method: UBTelemetricProtocol, logLevel: UBTelemetricLogLevel) -> String? {
        let date = Date()
        if featureBillaService.shouldLog(.telemetryLevel, logLevel: logLevel) {
            let logid = String(abs(date.hashValue))
            startTime[logid] = date
            let dataStruct = UBTelemetricResponse(logLevel, data: method)
            log[logid] = dataStruct
            return logid
        }
        return nil
    }

    /// This method accepts a keypath and value , and then updates the coressponing propeties in th UBAnalyticsRespons model and nested structs The loglevl could be lower than the main current log object.
    ///    - Parameter for: the value provided from the logStart.  If nill nothing will be logged
    ///    - Parameter keyPath: the property to alter in the UBAnalyticsRespons
    ///    - Parameter value:the value to set fot the ky
    ///    - Parameter logLevel: the loglevel this properties belongs to
    func alterData<Type, V>(for logId: String?, keyPath: WritableKeyPath<Type, V>, value: V, logLevel: UBTelemetricLogLevel) {
        if featureBillaService.shouldLog(.telemetryLevel, logLevel: logLevel) {
            guard let logId = logId, let dataToAlter = log[logId] else { return }

            dataToAlter.logs.forEach {
                $0.dataLogs.forEach {
                    if var object = $0 as? Type {
                        object[keyPath: keyPath] = value
                    }
                }
            }
            log[logId] = dataToAlter
        }
    }

    /// finish the time-meassure started in the logStart method. If there is a logId, logging should be done
    /// - Parameter logId: the logId provided by the logStart method. If nil or not found, nothing is logged.
    /// - Parameter keyPath: the  keypath, where the duration should be written. Keypath must be a double
    func logEnd<Type>(for logId: String?, keyPath: WritableKeyPath<Type, Double>) {
        guard let logId = logId else { return }
        if let startime = startTime[logId] {
            let endtime = Date()
            alterData(for: logId, keyPath: keyPath, value: endtime.timeIntervalSince(startime), logLevel: .all )
            startTime.removeValue(forKey: logId)
            updateFileStorrage(with: logId)
            return
        }
    }

    /// prints all data to the console
    func printlog() {
        do {
            try log.forEach {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode($1)
                if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(json)
                }
            }
        } catch {
            print("Error while creating json")
        }
    }

    fileprivate func updateFileStorrage(with logId: String) {
        guard let objectToAlter = log[logId] else {return}
        if saveToFile(component: objectToAlter) {
            log.removeValue(forKey: logId)
        }
    }

    fileprivate func getFileURL () -> URL? {
        let file = TelemetryConstants.filename

        let fileManager = FileManager.default
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filepath = dir.appendingPathComponent(TelemetryConstants.filepath, isDirectory: true).appendingPathComponent(file)
            return filepath
        }
        return nil
    }

    fileprivate func saveToFile(component: UBTelemetricResponse) -> Bool {
        guard let fileURL = getFileURL() else { return false}
        var dataToStore: UBTelemetricResponse
        if let currentData = loadFromJsonFile() {
            // add the data from logs in the current log
            currentData.logs.insert(contentsOf: component.logs, at: 0)
            dataToStore = currentData
        } else {
            dataToStore = component
        }
        while dataToStore.logs.count >= maxnumberOfEntries {
            dataToStore.logs.remove(at: dataToStore.logs.count-1)
        }
        do {
            let data = try JSONEncoder().encode(dataToStore)
            try data.write(to: fileURL)
            return true
        } catch {
            return false
        }
    }

    fileprivate func loadFromJsonFile() -> UBTelemetricResponse? {
        guard let fileURL = getFileURL() else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            if data.count > 0 {
                let decoder = JSONDecoder()
                let product = try decoder.decode(UBTelemetricResponse.self, from: data)
                return product
            }
            return nil
        } catch {
            return nil
        }
    }

    /// Get the current data as base64 encode json string,
    /// - Parameter flush: if false the data are not flushed, but left in the storrage, defaults to true
    /// - Returns: base64 encode string of the json
    func getStoredData(flush: Bool = true) -> String? {
        if let currentData = loadFromJsonFile() {
            guard let fileURL = getFileURL() else { return ""}
            do {
                if flush { try Data().write(to: fileURL) }
                let data =  try JSONEncoder().encode(currentData)
                return data.base64EncodedString()
            } catch {
                return nil
            }
        }
        return nil
    }

    /// Add data to the log. If data retrieved witht the getStoredData method fails the data can be added to the storrage again
    /// - Parameter data: BASE64 encode string
    /// - Returns: bool of the result. If the data was sucessfully decode and added it return true
    private func addLogData(data: String) -> Bool {
        let decoder = JSONDecoder()
        if let jsonData = Data(base64Encoded: data) {
             do {
                let products = try decoder.decode(UBTelemetricResponse.self, from: jsonData)
                return saveToFile(component: products)
            } catch {
                return false
            }
        }
        return false
    }

    /// Upload data to our server
    func submitLogData () {
        if !submitTelemetryData {return}
        var appId = UsabillaInternal.appID ?? ""
        if  appId == "" {
            appId = "noAppId"
        }
        if let storeData = getStoredData() {
            telemtricService.submitTelemtryData(appId: appId, body: storeData).then { _ in
                return
            }
        }
    }
}
