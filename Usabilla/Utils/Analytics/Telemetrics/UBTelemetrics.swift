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

    private var featureBillaService: UBFeatureBillaManagerProtocol
    init() {
        self.featureBillaService =  UBFeatureBillaManager()
    }
    /// Starts the logging (time) for an event. The returned id, must be use in  calls to alterData or logEnd. If nil is returned,
    /// when the log is started, its checked towards the percentage, and if inside the envelope,  all logging will occur. There is no
    /// test during alterData og logEnd.
    ///    - Parameter method: the method name to log must be lentgh > 0, else no loging will occur for the
    ///    - Parameter file: the file where the method to log is called from (defaults to empty string)
    ///    - Parameter line: the line number where the method to log is called from (defaults to 0)
    ///    - Parameter logLevel: the loglevel this log entry belongs to
    func logStart(method: String, logLevel: FeatureLogLevel) -> String? {
        let date = Date()
        if featureBillaService.shouldLog(.telemetrics, logLevel: logLevel) {
            let logid = String(abs(date.hashValue))
            startTime[logid] = date
            let dataStruct = UBTelemetricResponse(level: 2)
            dataStruct.methodData.methodName = method
            log[logid] = dataStruct
            return logid
        }
        return nil
    }

    /// This method accepts a keypath and value , and then updates the coressponing propeties in th UBAnalyticsRespons model and nested structs The loglevl could be lower than the main current log object.
    ///    - Parameter for: the value reciede from the logStart.  If nill nothing will be logged
    ///    - Parameter key: the property to alter in the UBAnalyticsRespons
    ///    - Parameter value:the value to set fot the ky
    ///    - Parameter logLevel: the loglevel this properties belongs to
    func alterData<V>(for logId: String?, key: WritableKeyPath<UBTelemetricResponse, V>, value: V, logLevel: FeatureLogLevel) {
        if featureBillaService.shouldLog(.telemetrics, logLevel: logLevel) {
            guard let logId = logId, var dataToAlter = log[logId] else { return }
                dataToAlter[keyPath: key] = value
                log[logId] = dataToAlter
        }
    }

    /// finish the time-meassure started in the logStart method. If there is a logId, logging should be done
    /// - Parameter logId: the logId provided by the logStart method. If nil or not found, nothing is logged.
    func logEnd(for logId: String?) {
        guard let logId = logId else { return }
        if let startime = startTime[logId] {
            let endtime = Date()
            alterData(for: logId, key: \UBTelemetricResponse.methodData.duration, value: endtime.timeIntervalSince(startime), logLevel: .all )
            startTime.removeValue(forKey: logId)
            return
        }
    }

    /// Log performance of subtask . provide the main logId for the current task, and data for the dub-task wil be added. Currently only non-closure operation will perform corret
    ///    - Parameter for: the value reciede from the logStart.  If nill nothing will be logged
    ///    - Parameter logLevel: the loglevel this properties belongs to
    func logSubTask(for logId: String?, logLevel: FeatureLogLevel) -> String? {
        let starttime = Date()
        guard logId != nil else { return nil }
        if featureBillaService.shouldLog(.telemetrics, logLevel: logLevel) {
            let logid = String(abs(starttime.hashValue))
            startTime[logid] = starttime
            return logid
        }
        return nil
    }

    /// finish the time-meassure started in the logSubTask method. It will only add en entry in the logid
    /// - Parameter logId: the logId provided by the logSubTask method. If nil or not found, nothing is logged.
    /// - Parameter parentId: the parent logId (retrieved from logStar)t. If nil or not found, nothing is logged.
    /// - Parameter name: the name to record in the log
    func logEndSubTask(for logId: String?, parentId: String?, name: String) {
        guard let logId = logId, let parentId = parentId else { return }
        guard let startime = startTime[logId],
            let objectToAlter = log[parentId] else {return}
        let endtime = Date()
        objectToAlter.performane.append(UBTelemetricPerformance(duration: endtime.timeIntervalSince(startime), methodName: name))
        startTime.removeValue(forKey: logId)
        return
    }

    /// prints all data to the console
    func printlog() {
        log.forEach {
            print("JSON String : " + $0.value.description)
        }
    }
}
