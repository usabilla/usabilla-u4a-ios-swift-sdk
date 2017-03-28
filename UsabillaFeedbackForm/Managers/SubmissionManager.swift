//
//  SubmissionManager.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol Reachable {
    func startNotifier() throws
    var whenReachable: ((Reachability) -> Void)? { get set }
    var isReachable: Bool { get }
    var currentReachabilityStatus: Reachability.NetworkStatus { get }
}

extension Reachability: Reachable { }

class SubmissionManager {

    static let shared = SubmissionManager(reachability: Reachability()!)
    private var reachability: Reachable
    fileprivate let submissionSerialQueue = DispatchQueue(label: "com.usabilla.u4a.submissionmanager")
    fileprivate let semaphore = DispatchSemaphore(value: 0)
    private func setUpReachability() {
        try? reachability.startNotifier()
    }

    private func trySendData() {
        submissionSerialQueue.async {
            guard let feedbackRequest = DataStore.feedbacks.first else {
                return
            }
            NetworkManager.submitFormToUsabilla(payload: feedbackRequest.payload, screenshot: feedbackRequest.screenshot).then { _ in
                DataStore.removeFeedback(index: 0)
                self.trySendData()
                self.semaphore.signal()
            }.catch { _ in
                self.semaphore.signal()
            }
            self.semaphore.wait()
        }
    }

    init(reachability: Reachable) {
        self.reachability = reachability
        self.reachability.whenReachable = { reachability in
            if self.reachability.isReachable {
                self.trySendData()
            }
        }
        setUpReachability()
    }

    func submit(form: FormModel, customVars: [String: Any]?) {
        let feedbackRequest = createSubmission(formModel: form, customVars: customVars)
        
        DataStore.addFeedback(type: feedbackRequest)
        if reachability.isReachable {
            trySendData()
        }
    }

    private func createSubmission(formModel: FormModel, customVars: [String: Any]?) -> FeedbackRequest {
        let uiDevice = UIDevice()
        var contentDictionary: [String: Any] = [:]
        contentDictionary["app_id"] = formModel.appId //String
        contentDictionary["version"] = formModel.version //String
        contentDictionary["SDK_version"] = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.object(forInfoDictionaryKey: "CFBundleShortVersionString")

        contentDictionary["data"] = formModel.toDictionnary()

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

        contentDictionary["app_version"] = Bundle.main.infoDictionary!["CFBundleVersion"]
        contentDictionary["app_name"] = Bundle.main.infoDictionary![kCFBundleNameKey as String]

        var screenshotString: String?
        if let screenshotModel = formModel.pages.first?.fields.last as? ScreenshotModel {
            if let screenshot = screenshotModel.base64Value {
                screenshotString = screenshot
            }
        }

        if customVars != nil {
            contentDictionary["custom_variables"] = customVars
        }

        if formModel.isDefault {
            contentDictionary["defaultForm"] = true
        }

        var payload: [String: Any] = [:]

        payload["type"] = "app_feedback"
        payload["subtype"] = "form"
        payload["v"] = NSNumber(value: 1 as Int32)
        payload["done"] = true
        payload["data"] = contentDictionary

        return FeedbackRequest(payload: payload, screenshot: screenshotString)
    }
}
