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
    }

    static let bundle = Bundle(for: NetworkManager.self)
    static let apiUrl: String = bundle.infoDictionary!["USABILLA_API_URL"] as! String
    static let submitUrl: String = bundle.infoDictionary!["USABILLA_SUBMIT_ENDPOINT"] as! String

    static let headers: [String: String]? = [
        "app-version": Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "",
        "app-name": Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? "",
        "sdk-version": Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
        "os": "iOS"
    ]

    /**
     Creates a URL
     
     @param endpoint: the endpoint of the URL
     
     @param param: parameter to add at the end of the URL
     
     @return and URL with endpoint and parameter
     */
    class func buildURL(withEndpoint endpoint: Endpoints, withURLParam param: String? = nil) -> URL {
        if let param = param {
            return URL(string: apiUrl.appending(endpoint.rawValue).appending(param))!
        }
        return URL(string: apiUrl.appending(endpoint.rawValue))!
    }

    /**
     Creates a basic GET request
     
     @param url: the url to use for the GET request
     
     @return the basic GET request
     */
    class func buildBaseGet(withURL url: URL) -> NSMutableURLRequest {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = headers

        return request
    }

    /**
     Creates a basic POST request
     
     @param url: the url to use for the POST request
     
     @param parameters: the parameters to use for the POST

     @return the basic POST request
     */
    class func buildBasePost(withURL url: URL, parameters: Parameters) -> NSMutableURLRequest {
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

    class func buildGetCampaignForm(withFormId id: String) -> URLRequest {
        let url = buildURL(withEndpoint: .campaignForm, withURLParam: id)
        return buildBaseGet(withURL: url) as URLRequest
    }

}
