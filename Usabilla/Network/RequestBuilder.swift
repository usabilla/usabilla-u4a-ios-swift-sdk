//
//  RequestHandler.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 13/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
// swiftlint:disable force_unwrapping
class RequestBuilder {

    enum Endpoints: String {
        case campaignForm = "/forms"
        case passiveForm = "/live/mobile/app/forms"
        case campaignsList = "/campaigns?app_id={app_id}"
        case targetingOptions = "/targeting-options"
        case campaignSubmission = "/v2/sdk/campaigns/{campaign_id}/feedback"
        case campaignViews = "/v2/sdk/campaigns/{campaign_id}/views"
    }

    static let bundle = Bundle(for: RequestBuilder.self)
    // swiftlint:disable force_cast
    static let apiUrl: String = bundle.infoDictionary!["USABILLA_API_HOST"] as! String
    static let submitUrl: String = bundle.infoDictionary!["USABILLA_SUBMIT_ENDPOINT"] as! String
    static let cdnUrl: String = bundle.infoDictionary!["USABILLA_CDN_HOST"] as! String
    // swiftlint:enable force_cast
    static let headers: [String: String] = [
        "app-version": Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "",
        "app-name": Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? "",
        "sdk-version": Bundle(identifier: "com.usabilla.Usabilla")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
        "os": "iOS"
    ]

    /**
     Creates a URL

     - Parameter baseUrl: the host URL

     - Parameter endpoint: the endpoint of the URL
     
     - Parameter param: parameter to add at the end of the URL
     
     - Return: and URL with endpoint and parameter
     */
    private class func buildURL(withBaseUrl baseUrl: String, withEndpoint endpoint: Endpoints, withURLParam param: String? = nil) -> URL {
        if let param = param {
            return URL(string: baseUrl.appending(endpoint.rawValue).appending("/").appending(param))!
        }
        return URL(string: baseUrl.appending(endpoint.rawValue))!
    }

    /**
     Creates a URL

     - Parameter baseUrl: the host URL

     - Parameter endpoint: the endpoint of the URL

     - Parameter param: parameter to add at the end of the URL

     - Return: and URL with endpoint and parameter
     */
    private class func buildURL(withBaseUrl baseUrl: String, withString endpoint: String, withURLParam param: String? = nil) -> URL {
        if let param = param {
            return URL(string: baseUrl.appending(endpoint).appending("/").appending(param))!
        }
        return URL(string: baseUrl.appending(endpoint))!
    }

    fileprivate static func buildSharedRequest(_ url: URL, method: HTTPMethod) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 10
        return request
    }

    /**
     Creates a basic GET request
     
     - Parameter url: the url to use for the GET request
     
     - Return: the basic GET request
     */
    private class func requestForGet(withURL url: URL) -> URLRequest {
        return buildSharedRequest(url, method: .get) as URLRequest
    }

    /**
     Creates a basic POST request
     
     - Parameter url: the url to use for the POST request
     
     - Parameter parameters: the parameters to use for the POST

     - Return: the basic POST request
     */
    private class func requestForPost(withURL url: URL, payload: Parameters) -> URLRequest {
        var request = buildSharedRequest(url, method: .post)
        do {
            request = try JSONEncoding.default.encode(request, with: payload)
        } catch {
            //Do intelligent stuff with error
        }

        return request as URLRequest
    }

    /**
     Creates a basic PATCH request

     - Parameter url: the url to use for the PATCH request

     - Parameter parameters: the parameters to use for the PATCH

     - Return: the basic PATCH request
     */
    private class func requestForPatch(withURL url: URL, payload: Parameters) -> URLRequest {
        var request = buildSharedRequest(url, method: .patch)
        do {
            request = try JSONEncoding.default.encode(request, with: payload)
        } catch {
            //Do intelligent stuff with error
        }

        return request as URLRequest
    }

    // MARK: Public methods

    // MARK: Reading

    class func requestGetPassiveForm(withID id: String) -> URLRequest {
        let url = buildURL(withBaseUrl: apiUrl, withEndpoint: .passiveForm, withURLParam: id)
        return requestForGet(withURL: url)
    }

    class func requestGetCampaignForm(withID id: String) -> URLRequest {
        let url = buildURL(withBaseUrl: cdnUrl, withEndpoint: .campaignForm, withURLParam: id)
        return requestForGet(withURL: url)
    }

    class func requestGetCampaigns(withAppID appID: String) -> URLRequest {
        let endPoint = Endpoints.campaignsList.rawValue.replacingOccurrences(of: "{app_id}", with: appID)
        let url = buildURL(withBaseUrl: cdnUrl, withString: endPoint)
        return requestForGet(withURL: url)
    }

    class func requestGetTargeting(withID id: String) -> URLRequest {
        let url = buildURL(withBaseUrl: cdnUrl, withEndpoint: .targetingOptions, withURLParam: id)
        return requestForGet(withURL: url)
    }

    // MARK: Writing

    class func requestCampaignFeedbackItemCreation(forCampaignID campaignID: String, withPayload payload: Payload) -> URLRequest {
        let endPoint = Endpoints.campaignSubmission.rawValue
        let newEndPoint = endPoint.replacingOccurrences(of: "{campaign_id}", with: campaignID)
        let url = buildURL(withBaseUrl: apiUrl, withString: newEndPoint)
        return requestForPost(withURL: url, payload: payload)
    }

    class func requestCampaignFeedbackItemPatch(forCampaignID campaignID: String, withPayload payload: Payload, withSessionToken token: String) -> URLRequest {
        let endPoint = Endpoints.campaignSubmission.rawValue
        let newEndPoint = endPoint.replacingOccurrences(of: "{campaign_id}", with: campaignID)
        let url = buildURL(withBaseUrl: apiUrl, withString: newEndPoint, withURLParam: token)
        return requestForPatch(withURL: url, payload: payload)
    }

    class func requestPatchCampaignViews(forCampaignID campaignID: String, viewCount: Int) -> URLRequest {
        let endPoint = Endpoints.campaignViews.rawValue
        let newEndPoint = endPoint.replacingOccurrences(of: "{campaign_id}", with: campaignID)
        let url = buildURL(withBaseUrl: apiUrl, withString: newEndPoint)
        return requestForPatch(withURL: url, payload: ["view": viewCount])
    }
}
