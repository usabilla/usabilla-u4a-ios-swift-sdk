//
//  HTTPClient.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 17/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct HTTPClientResponse {
    let data: Any?
    let error: NSError?
    let success: Bool
    let isChanged: Bool

    init(data: Any?, error: NSError?, success: Bool = false, isChanged: Bool = false) {
        self.data = data
        self.error = error
        self.success = success
        self.isChanged = isChanged
    }
}

typealias Parameters = [String: Any]
typealias Payload = Parameters
typealias HTTPHeaders = [String: String]

protocol ParameterEncoding {
    func encode(_ urlRequest: NSMutableURLRequest, with parameters: Parameters?) throws -> NSMutableURLRequest
}

class JSONEncoding: ParameterEncoding {

    static var `default`: JSONEncoding { return JSONEncoding() }

    func encode(_ urlRequest: NSMutableURLRequest, with parameters: Parameters?) throws -> NSMutableURLRequest {

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw error
        }

        return urlRequest
    }
}

class HTTPClient: HTTPClientProtocol {

    static func request(request: URLRequest,
                        responseQueue: DispatchQueue? = nil,
                        completion: @escaping (HTTPClientResponse) -> Void) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            (responseQueue ?? DispatchQueue.main).async {
                PLog(response)

                guard error == nil else {
                    completion(HTTPClientResponse(data: nil, error: NSError(domain: error.debugDescription, code: 0, userInfo: nil)))
                    return
                }
                guard let data = data else {
                    completion(HTTPClientResponse(data: nil, error: NSError(domain: "No reponse Data", code: 1, userInfo: nil)))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    PLog(json)
                    completion(HTTPClientResponse(data: json, error: nil, success: true))
                } catch {
                    completion(HTTPClientResponse(data: nil, error: NSError(domain: "Invalid JSON", code: 2, userInfo: nil)))
                }
            }
        }
        task.resume()
    }

    static func request(_ url: String,
                        method: HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        encoding: ParameterEncoding = JSONEncoding.default,
                        headers: HTTPHeaders? = nil,
                        responseQueue: DispatchQueue? = nil,
                        completion: @escaping (HTTPClientResponse) -> Void) {

        guard let url = URL(string: url) else {
            return
        }

        var request = NSMutableURLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = method.rawValue

        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }

        do {
            request = try encoding.encode(request, with: parameters)
        } catch {
            completion(HTTPClientResponse(data: nil, error: error as NSError?, success: false))
            return
        }
        HTTPClient.request(request: request as URLRequest, responseQueue: responseQueue, completion: completion)
    }
}
