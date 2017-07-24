//
//  RequestHandler.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 13/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
// swiftlint:disable force_unwrapping
class RequestBuilder {

    enum Endpoints: String {
        case campaignForm = "/v2/sdk/forms"
        case passiveForm = "/live/mobile/app/forms"
        case campaignsList = "/v2/sdk/campaigns?app_id={app_id}"
        case targetingOptions = "/v2/sdk/targeting-options"
        case campaignSubmission = "/v2/sdk/campaigns/{campaign_id}/feedback"
        case campaignViews = "/v2/sdk/campaigns/{campaign_id}/views"
    }

    static let bundle = Bundle(for: RequestBuilder.self)
    // swiftlint:disable force_cast
    static let apiUrl: String = bundle.infoDictionary!["USABILLA_API_URL"] as! String
    static let submitUrl: String = bundle.infoDictionary!["USABILLA_SUBMIT_ENDPOINT"] as! String
    // swiftlint:enable force_cast
    static let headers: [String: String] = [
        "app-version": Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "",
        "app-name": Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? "",
        "sdk-version": Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
        "os": "iOS"
    ]

    /**
     Creates a URL
     
     - Parameter endpoint: the endpoint of the URL
     
     - Parameter param: parameter to add at the end of the URL
     
     - Return: and URL with endpoint and parameter
     */
    private class func buildURL(withEndpoint endpoint: Endpoints, withURLParam param: String? = nil) -> URL {
        if let param = param {
            return URL(string: apiUrl.appending(endpoint.rawValue).appending("/").appending(param))!
        }
        return URL(string: apiUrl.appending(endpoint.rawValue))!
    }

    /**
     Creates a URL

     - Parameter endpoint: the endpoint of the URL

     - Parameter param: parameter to add at the end of the URL

     - Return: and URL with endpoint and parameter
     */
    private class func buildURL(withString endpoint: String, withURLParam param: String? = nil) -> URL {
        if let param = param {
            return URL(string: apiUrl.appending(endpoint).appending("/").appending(param))!
        }
        return URL(string: apiUrl.appending(endpoint))!
    }

    /**
     Creates a basic GET request
     
     - Parameter url: the url to use for the GET request
     
     - Return: the basic GET request
     */
    private class func requestForGet(withURL url: URL) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = headers

        return request
    }

    /**
     Creates a basic POST request
     
     - Parameter url: the url to use for the POST request
     
     - Parameter parameters: the parameters to use for the POST

     - Return: the basic POST request
     */
    private class func requestForPost(withURL url: URL, payload: Parameters) -> NSMutableURLRequest {
        var request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers

        do {
            request = try JSONEncoding.default.encode(request, with: payload)
        } catch {
            //Do intelligent stuff with error
        }

        return request
    }

    /**
     Creates a basic PATCH request

     - Parameter url: the url to use for the PATCH request

     - Parameter parameters: the parameters to use for the PATCH

     - Return: the basic PATCH request
     */
    private class func requestForPatch(withURL url: URL, payload: Parameters) -> NSMutableURLRequest {
        var request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = HTTPMethod.patch.rawValue
        request.allHTTPHeaderFields = headers

        do {
            request = try JSONEncoding.default.encode(request, with: payload)
        } catch {
            //Do intelligent stuff with error
        }

        return request
    }

    // MARK: Public methods
    class func requestGetPassiveForm(withId id: String) -> URLRequest {
        let url = buildURL(withEndpoint: .passiveForm, withURLParam: id)
        return requestForGet(withURL: url) as URLRequest
    }

    class func requestGetCampaignForm(withId id: String) -> URLRequest {
        let url = buildURL(withEndpoint: .campaignForm, withURLParam: id)
        return requestForGet(withURL: url) as URLRequest
    }

    class func requestGetCampaigns(withAppId appId: String) -> URLRequest {
        let endPoint = Endpoints.campaignsList.rawValue.replacingOccurrences(of: "{app_id}", with: appId)
        let url = buildURL(withString: endPoint)
        return requestForGet(withURL: url) as URLRequest
    }

    class func requestGetTargeting(withId id: String) -> URLRequest {
        let url = buildURL(withEndpoint: .targetingOptions, withURLParam: id)
        return requestForGet(withURL: url) as URLRequest
    }

    class func requestCampaignFeedbackItemCreation(forCampaignId campaignId: String, withPayload payload: Payload) -> URLRequest {
        let endPoint = Endpoints.campaignSubmission.rawValue
        let newEndPoint = endPoint.replacingOccurrences(of: "{campaign_id}", with: campaignId)
        let url = buildURL(withString: newEndPoint)
        return requestForPost(withURL: url, payload: payload) as URLRequest
    }

    class func requestCampaignFeedbackItemPatch(forCampaignId campaignId: String, withPayload payload: Payload, withSessionToken token: String) -> URLRequest {
        let endPoint = Endpoints.campaignSubmission.rawValue
        let newEndPoint = endPoint.replacingOccurrences(of: "{campaign_id}", with: campaignId)
        let url = buildURL(withString: newEndPoint, withURLParam: token)
        return requestForPatch(withURL: url, payload: payload) as URLRequest
    }

    class func requestPatchCampaignViews(forCampaignId campaignId: String, viewCount: Int) -> URLRequest {
        let endPoint = Endpoints.campaignViews.rawValue
        let newEndPoint = endPoint.replacingOccurrences(of: "{campaign_id}", with: campaignId)
        let url = buildURL(withString: newEndPoint)
        return requestForPatch(withURL: url, payload: ["view": viewCount]) as URLRequest
    }
}
