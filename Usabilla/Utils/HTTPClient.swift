//
//  HTTPClient.swift
//  Usabilla
//
//  Created by Benjamin Grima on 17/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
}

struct HTTPClientResponse {
    let data: Any?
    let error: NSError?
    let success: Bool
    let isChanged: Bool
    let headers: [AnyHashable: Any]?

    init(data: Any?, headers: [AnyHashable: Any]? = nil, error: NSError?, success: Bool = false, isChanged: Bool = false) {
        self.headers = headers
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

    static private func getEtag(forRequest request: URLRequest) -> String? {
        guard let cached = URLCache.shared.cachedResponse(for: request),
            let rep = cached.response as? HTTPURLResponse,
            let etag = rep.allHeaderFields["Etag"] as? String else {
                return nil
        }
        return etag
    }

    static func hasChanged(oldEtag: String?, newEtag: String?) -> Bool {
        guard oldEtag != nil || newEtag != nil else {
            return true
        }
        return oldEtag != newEtag
    }

    static func request(request: URLRequest,
                        responseQueue: DispatchQueue? = nil,
                        allowNilData: Bool = false,
                        completion: @escaping (HTTPClientResponse) -> Void) {
        let oldEtag = getEtag(forRequest: request)

        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            (responseQueue ?? DispatchQueue.main).async {
                PLog(response)
                let headers = (response as? HTTPURLResponse)?.allHeaderFields
                let isChanged = hasChanged(oldEtag: oldEtag, newEtag: headers?["Etag"] as? String)

                guard error == nil else {
                    completion(HTTPClientResponse(data: nil, error: NSError(domain: error.debugDescription, code: 0, userInfo: nil)))
                    return
                }
                guard let data = data, data.count > 0 else {
                    if allowNilData {
                        completion(HTTPClientResponse(data: nil, headers: headers, error: nil, success: true, isChanged: isChanged))
                        return
                    }
                    completion(HTTPClientResponse(data: nil, error: NSError(domain: "No reponse Data", code: 1, userInfo: nil)))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    PLog(json)
                    completion(HTTPClientResponse(data: json, headers: headers, error: nil, success: true, isChanged: isChanged))
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
                        allowNilData: Bool = false,
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
