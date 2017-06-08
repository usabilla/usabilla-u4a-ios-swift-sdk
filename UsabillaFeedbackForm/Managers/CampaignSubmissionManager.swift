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

    let appId: String
    let campaignId: String
    let formVersion: Int
    let reachability: Reachable
    let customVars: [String: Any]?
    let submissionService: CampaignServiceProtocol
    var feedbackId: String?

    fileprivate let tokenQueue: DispatchQueue

    var requestQueue: [UBCampaignFeedbackRequest]

    init(appId: String, campaignId: String, formVersion: Int, customVars: [String: Any]?, campaignService: CampaignServiceProtocol, reachability: Reachable = Reachability()!) {
        self.appId = appId
        self.formVersion = formVersion
        self.customVars = customVars
        self.campaignId = campaignId
        self.submissionService = campaignService
        self.reachability = reachability
        try? reachability.startNotifier()
        tokenQueue = DispatchQueue(label: "com.usabilla.u4a.campaignsubmissionmanager.token")
        requestQueue = []
    }

    func submitPage(page: PageModel) {

        if page.type == .start {
            submitMetadata(page: page)
            return
        }

        if page.type == .end {
            submitClose(page: page)
            return
        }

        submitSinglePage(page: page)
    }


    private func submitMetadata(page: PageModel) {
        var payload: [String: Any] = ["data": page.toJSONDictionary()]
        payload = addMetadataPayload(payload: payload)
        let request = buildRequest(withPayload: payload)
        submitToService(withRequest: request, type: .metadata)
    }

    private func submitSinglePage(page: PageModel) {
        let payload: [String: Any] = ["data": page.toJSONDictionary()]
        let request = buildRequest(withPayload: payload)
        submitOrCache(withRequest: request, type: .page)
    }

    private func submitClose(page: PageModel) {
        var payload: [String: Any] = ["data": page.toJSONDictionary()]
        payload["complete"] = true
        let request = buildRequest(withPayload: payload)
        submitOrCache(withRequest: request, type: .close)
    }

    private func submitOrCache(withRequest request: URLRequest, type: RequestType) {
        tokenQueue.sync {
            if feedbackId != nil {
                submitToService(withRequest: request, type: type)
            } else {
                requestQueue.append(UBCampaignFeedbackRequest(request: request, type: type))
            }
        }
    }

    private func submitToService(withRequest request: URLRequest, type: RequestType) {
        submissionService.submitCampaignResult(withRequest: request).then { token in
            self.tokenQueue.sync {
                if self.feedbackId == nil {
                    self.feedbackId = token
                    self.submitQueue()
                }
            }
        }.catch { _ in
            self.requestQueue.append(UBCampaignFeedbackRequest(request: request, type: type))
        }
    }

    private func submitQueue() {
        for request in requestQueue {
            submitToService(withRequest: request.request, type: request.type)
        }
        requestQueue = []
    }

    private func buildRequest(withPayload payload: Payload) -> URLRequest {
        return RequestBuilder.requestCampaignFeedbackSubmission(forCampaignId: campaignId, withPayload: payload, withSessionToken: feedbackId) as URLRequest
    }

    private func addMetadataPayload(payload: [String: Any]) -> [String: Any] {
        var payload = payload
        let uiDevice = UIDevice()
        let screenBounds = UIScreen.main.bounds
        var metadata: [String: Any] = [:]
        UIDevice.current.isBatteryMonitoringEnabled = true

        payload["app_id"] = appId
        payload["version"] = formVersion
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
