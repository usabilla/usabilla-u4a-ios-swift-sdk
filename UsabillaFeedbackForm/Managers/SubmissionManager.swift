//
//  SubmissionManager.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension Reachability: Reachable { }

class SubmissionManager {

    var userContext: [String: Any] = [:]
    private var reachability: Reachable
    private var formService: FormServiceProtocol

    fileprivate let submissionSerialQueue = DispatchQueue(label: "com.usabilla.u4a.submissionmanager")
    fileprivate let semaphore = DispatchSemaphore(value: 0)
    private func setUpReachability() {
        try? reachability.startNotifier()
    }

    private func trySendData() {
        submissionSerialQueue.async {
            guard let feedbackRequest = UBFeedbackRequestDAO.shared.readAll().first else {
                return
            }
            self.formService.submitForm(payload: feedbackRequest.payload, screenshot: feedbackRequest.screenshot).then { _ in
                UBFeedbackRequestDAO.shared.delete(feedbackRequest)
                self.trySendData()
                self.semaphore.signal()
            }.catch { _ in
                self.semaphore.signal()
            }
            self.semaphore.wait()
        }
    }

    init(formService: FormServiceProtocol, reachability: Reachable = Reachability()!) {
        self.formService = formService
        self.reachability = reachability
        self.reachability.whenReachable = { reachability in
            if self.reachability.isReachable {
                self.trySendData()
            }
        }
        setUpReachability()
    }

    func submit(form: FormModel) {
        let feedbackRequest = createSubmission(formModel: form)

        UBFeedbackRequestDAO.shared.create(feedbackRequest)
        if reachability.isReachable {
            trySendData()
        }
    }

    private func createSubmission(formModel: FormModel) -> UBFeedbackRequest {
        let uiDevice = UIDevice()
        var contentDictionary: [String: Any] = [:]
        contentDictionary["app_id"] = formModel.identifier //String
        contentDictionary["version"] = formModel.version //String

        if let SDKVersion = Bundle(identifier: "com.usabilla.Usabilla")?.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            contentDictionary["SDK_version"] = SDKVersion
        } else {
            PLog("❌ impossible to get SDK version")
        }

        contentDictionary["data"] = formModel.toDictionary()

        contentDictionary["timestamp"] = String(format: "%.0f", arguments: [Date().timeIntervalSince1970])

        contentDictionary["device"] = uiDevice.modelName

        contentDictionary["system"] = "ios"
        contentDictionary["os_version"] = uiDevice.systemVersion
        UIDevice.current.isBatteryMonitoringEnabled = true
        contentDictionary["battery"] = UIDevice.current.batteryLevel
        contentDictionary["lang"] = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode)
        contentDictionary["orientation"] = UIDeviceOrientationIsLandscape(uiDevice.orientation) ? "Landscape" : "Portrait"

        contentDictionary["reachability"] = reachability.currentReachabilityStatus.description

        contentDictionary["free_space"] = Int(DeviceInfo.DiskStatus.freeDiskSpaceInBytes / 1024)
        contentDictionary["total_space"] = Int(DeviceInfo.DiskStatus.totalDiskSpaceInBytes / 1024)
        contentDictionary["rooted"] = DeviceInfo.isJailbroken()

        let screenBounds = UIScreen.main.bounds
        contentDictionary["screensize"] = "\(Int(screenBounds.width)) x \(Int(screenBounds.height))"

        if let appVersion = Bundle.main.infoDictionary?["CFBundleVersion"] {
            contentDictionary["app_version"] = appVersion
        } else {
            PLog("❌ impossible to get host app version")
        }

        if let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] {
            contentDictionary["app_name"] = appName
        } else {
            PLog("❌ impossible to get host app name")
        }

        var screenshotString: String?
        if let screenshotModel = formModel.pages.first?.fields.last as? ScreenshotModel {
            if let screenshot = screenshotModel.base64Value {
                screenshotString = screenshot
            }
        }

        contentDictionary["custom_variables"] = userContext

        var payload: [String: Any] = [:]

        payload["type"] = "app_feedback"
        payload["subtype"] = "form"
        payload["v"] = NSNumber(value: 1 as Int32)
        payload["done"] = true
        payload["data"] = contentDictionary

        return UBFeedbackRequest(payload: payload, screenshot: screenshotString)
    }
}
