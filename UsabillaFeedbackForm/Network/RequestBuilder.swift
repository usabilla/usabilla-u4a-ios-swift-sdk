//
//  RequestHandler.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 13/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable force_cast

class RequestBuilder {

    enum Endpoints: String {
        case campaignForm = "/v2/sdk/forms/"
        case passiveForm = "/live/mobile/app/forms/"
        case campaignsForAppId = "endpoint-here" // TO DO: change this when right end point is ready
        case targetingForCampaignId = "targeting-endpoint-here" // TO DO: change this when right end point is ready
    }

    static let bundle = Bundle(for: NetworkManager.self)
    static let apiUrl: String = bundle.infoDictionary!["USABILLA_API_URL"] as! String
    static let submitUrl: String = bundle.infoDictionary!["USABILLA_SUBMIT_ENDPOINT"] as! String

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
            return URL(string: apiUrl.appending(endpoint.rawValue).appending(param))!
        }
        return URL(string: apiUrl.appending(endpoint.rawValue))!
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
    private class func requestForPost(withURL url: URL, parameters: Parameters) -> NSMutableURLRequest {
        var request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers

        do {
            request = try JSONEncoding.default.encode(request, with: parameters)
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
        let url = buildURL(withEndpoint: .campaignsForAppId, withURLParam: appId)
        return requestForGet(withURL: url) as URLRequest
    }

    class func requestGetTargeting(withId id: String) -> URLRequest {
        let url = buildURL(withEndpoint: .targetingForCampaignId, withURLParam: id)
        return requestForGet(withURL: url) as URLRequest
    }
}
