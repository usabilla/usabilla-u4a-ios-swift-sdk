//
//  CampaignSubmissionManager.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 24/05/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

enum RequestType {
    case close
    case page
    case metadata
}

class UBCampaignFeedbackRequest {
    let request: URLRequest
    let type: RequestType

    init(request: URLRequest, type: RequestType) {
        self.request = request
        self.type = type
    }
}

class CampaignSubmissionManager {

    private let appId: String
    private let campaignId: String
    private let formVersion: Int
    private let reachability: Reachable
    private let customVars: [String: Any]?
    private let submissionService: CampaignServiceProtocol
    private let feedbackId: UUID
    private var isFirst: Bool
    private var queue: DispatchQueue

    init(appId: String, campaignId: String, formVersion: Int, customVars: [String: Any]?, campaignService: CampaignServiceProtocol, reachability: Reachable = Reachability()!) {
        self.appId = appId
        self.formVersion = formVersion
        self.customVars = customVars
        self.campaignId = campaignId
        self.submissionService = campaignService
        self.reachability = reachability
        try? reachability.startNotifier()
        self.feedbackId = UUID.init()
        self.isFirst = true
        self.queue = DispatchQueue(label: "com.usabilla.u4a.isFristQueue")
    }

    func submitPage(page: PageModelProtocol, nextPageType: PageType) {
        var payload: [String: Any] = ["data": page.toJSONDictionary()]

        if page.type == .start || page.type == .banner {
            payload = addMetadataPayload(payload: payload)
            payload["id"] = feedbackId.uuidString
        }

        if nextPageType == .end || nextPageType == .toast {
            payload["complete"] = true
        }

        let request = buildRequest(withPayload: payload)
        submitToService(withRequest: request)
    }

    private func submitToService(withRequest request: URLRequest) {
        submissionService.submitCampaignResult(withRequest: request)
    }

    private func buildRequest(withPayload payload: Payload) -> URLRequest {
        var req: URLRequest!
        queue.sync {
            if isFirst {
                isFirst = false
                req = RequestBuilder.requestCampaignFeedbackSubmission(forCampaignId: campaignId, withPayload: payload, withSessionToken: nil) as URLRequest
            } else {
                req = RequestBuilder.requestCampaignFeedbackSubmission(forCampaignId: campaignId, withPayload: payload, withSessionToken: feedbackId.uuidString) as URLRequest
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

        payload["app_id"] = appId
        payload["form_version"] = formVersion
        payload["complete"] = false

        metadata["app_version"] = Bundle.main.infoDictionary!["CFBundleVersion"]
        metadata["battery"] = UIDevice.current.batteryLevel
        metadata["network_connection"] = reachability.currentReachabilityStatus.description
        metadata["device"] = uiDevice.modelName
        metadata["language"] = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode)
        metadata["orientation"] = UIDeviceOrientationIsLandscape(uiDevice.orientation) ? "Landscape" : "Portrait"
        metadata["os_version"] = uiDevice.systemVersion
        metadata["screen"] = "\(Int(screenBounds.width)) x \(Int(screenBounds.height))"
        metadata["sdk_version"] = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        metadata["system"] = "ios"
        metadata["timestamp"] = Date().timeIntervalSince1970.description
        metadata["app_name"] = Bundle.main.infoDictionary![kCFBundleNameKey as String]

        if customVars != nil {
            metadata["custom_variables"] = customVars
        }

        payload["metadata"] = metadata

        return payload
    }

}
