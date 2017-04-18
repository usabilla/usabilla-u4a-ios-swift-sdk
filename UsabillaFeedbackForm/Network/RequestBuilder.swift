//
//  RequestHandler.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 13/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class RequestBuilder {

    static let bundle = Bundle(for: NetworkManager.self)
    static let apiUrl = bundle.infoDictionary!["USABILLA_API_URL"] as? String ?? ""
    static let submitUrl = bundle.infoDictionary!["USABILLA_SUBMIT_ENDPOINT"] as? String ?? ""
    //static let getCampaignsUrl = bundle.infoDictionary!["USABILLA_SUBMIT_ENDPOINT"] as? String ?? ""

    static let headers: [String: String]? = [
        "app-version": Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "",
        "app-name": Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? "",
        "sdk-version": Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
        "os": "iOS"
    ]

    private class func buildBaseGet(withURL url: URL, withHTTPMethod method: HTTPMethod) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        return request
    }

    class func buildGetAllCampaigns() -> NSMutableURLRequest {
        let url = URL(string: apiUrl)!
        let urlRequest = buildBaseGet(withURL: url, withHTTPMethod: HTTPMethod.get)
        return urlRequest
    }

}
