//
//  CampaignSubmissionRequestManager.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 24/05/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

enum RequestType: String {
    case close
    case page
    case start
}

protocol CampaignSubmissionRequestManagerProtocol {
    func savePage(page: PageModelProtocol, nextPageType: PageType)
}

class CampaignSubmissionRequestManager: CampaignSubmissionRequestManagerProtocol {

    private let appID: String
    private let campaignID: String
    private let formVersion: Int
    private let reachability: Reachable
    private let userContext: [String: Any]?
    private let feedbackID: String
    private let queue: DispatchQueue
    private let campaignSubmissionManager: CampaignSubmissionManagerProtocol

    private var isFirst: Bool

    // swiftlint:disable:next force_unwrapping
    init(appID: String, campaignID: String, formVersion: Int, userContext: [String: Any]?, campaignSubmissionManager: CampaignSubmissionManagerProtocol, reachability: Reachable = Reachability()!) {
        self.appID = appID
        self.formVersion = formVersion
        self.userContext = userContext
        self.campaignID = campaignID
        self.reachability = reachability
        try? reachability.startNotifier()
        self.feedbackID = UUID().uuidString
        self.isFirst = true
        self.queue = DispatchQueue(label: "com.usabilla.u4a.isFristQueue")
        self.campaignSubmissionManager = campaignSubmissionManager
    }

    func savePage(page: PageModelProtocol, nextPageType: PageType) {
        var payload: [String: Any] = ["data": page.toDictionary()]

        if page.type == .banner {
            payload = addMetadataPayload(payload: payload)
        }

        if nextPageType == .toast {
            payload["complete"] = true
        }

        let request = buildRequest(withPayload: payload)
        saveToStore(withRequest: request)
    }

    private func saveToStore(withRequest request: URLRequest) {
        let request = UBCampaignFeedbackRequest(request: request, internalID: feedbackID)
        campaignSubmissionManager.handle(request: request)
    }

    private func buildRequest(withPayload payload: Payload) -> URLRequest {
        var req: URLRequest!
        queue.sync {
            if isFirst {
                isFirst = false
                req = RequestBuilder.requestCampaignFeedbackItemCreation(forCampaignID: campaignID, withPayload: payload)
            } else {
                req = RequestBuilder.requestCampaignFeedbackItemPatch(forCampaignID: campaignID, withPayload: payload, withSessionToken: feedbackID)
            }
        }
        return req
    }

    private func addMetadataPayload(payload: [String: Any]) -> [String: Any] {
        var payload = payload
        let uiDevice = UIDevice()
        let screenBounds = UIScreen.main.bounds
        var metadata: [String: Any] = [:]
        UIDevice.current.isBatteryMonitoringEnabled = true

        payload["app_id"] = appID
        payload["form_version"] = formVersion
        payload["complete"] = false

        metadata["app_version"] = Bundle.main.infoDictionary!["CFBundleVersion"]
        metadata["battery"] = abs(UIDevice.current.batteryLevel)
        metadata["network_connection"] = reachability.currentReachabilityStatus.description
        metadata["device"] = uiDevice.modelName
        metadata["language"] = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode)
        metadata["orientation"] = UIDeviceOrientationIsLandscape(uiDevice.orientation) ? "Landscape" : "Portrait"
        metadata["os_version"] = uiDevice.systemVersion
        metadata["screen"] = "\(Int(screenBounds.width)) x \(Int(screenBounds.height))"
        metadata["sdk_version"] = Bundle(identifier: "com.usabilla.Usabilla")!.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        metadata["system"] = "ios"
        metadata["timestamp"] = Date().timeIntervalSince1970.description
        metadata["app_name"] = Bundle.main.infoDictionary![kCFBundleNameKey as String]

        if userContext != nil {
            payload["context"] = userContext
        }

        payload["metadata"] = metadata

        return payload
    }

}
