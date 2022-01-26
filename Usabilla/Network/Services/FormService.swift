//
//  FormService.swift
//  Usabilla
//
//  Created by Adil Bougamza on 23/05/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol FormServiceProtocol {
    var requestBuilder: RequestBuilder.Type { get }
    var httpClient: HTTPClientProtocol.Type { get }

    func getForm(withID id: String, screenShot: UIImage?, maskModel: MaskModel?, client: ClientModel) -> Promise<FormModel>
    func submitForm(payload: [String: Any], screenshot: String?) -> Promise<Bool>
}

class FormService: FormServiceProtocol {

    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type
    weak var telemetric: UBTelemetrics?

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getForm(withID id: String, screenShot: UIImage?, maskModel: MaskModel?, client: ClientModel) -> Promise<FormModel> {
        let request = requestBuilder.requestGetPassiveForm(withID: id)
        return Promise { fulfill, reject in
            guard let request = request else {
                PLog("❌ not a valid url parameter")
                reject(NSError(domain: "not a valid url parameter", code: 999, userInfo: nil))
                return
            }
            httpClient.request(request: request, responseQueue: nil, allowNilData: false) { response in
                if let json = response.data {
                    guard let formModel = FormModel(json: JSON(json),
                                                    id: id,
                                                    screenshot: screenShot,
                                                    maskModel: maskModel, client: client) else {
                                                        reject(NSError(domain: "form model is not valid", code: 0, userInfo: nil))
                                                        return
                    }
                    fulfill(formModel)
                    return
                }
                guard let error = response.error else {
                    PLog("❌ error missing from response")
                    reject(NSError(domain: "error missing from response", code: 0, userInfo: nil))
                    return
                }
                reject(error)
            }
        }
    }

    func submitForm(payload: [String: Any], screenshot: String?) -> Promise<Bool> {
        return Promise { fulfill, reject in
            submitFeedbackSmallData(payload: payload).then { response -> Void in
                guard let data = response.data else {
                    reject(NSError(domain: "no response", code: 0, userInfo: nil))
                    return
                }
                let json = JSON(data)
                let id = json["id"].stringValue
                let signature = json["sig"].stringValue
                if let screenshot = screenshot {
                    self.submitFeedbackScreenshot(id: id, signature: signature, screenshot: screenshot).then { _ in
                        fulfill(true)
                    }.catch { err in
                        reject(err)
                    }
                } else {
                    fulfill(true)
                }
            }.catch { error in
                reject(error)
                PLog(error)
            }
        }
    }

    /// Submits the screenshot as a separate request
    ///
    /// - Parameters:
    ///   - id: ID of the data that the screenshot must be added to. (Widget server data)
    ///   - signature: Same as ID
    ///   - screenshot: base64 representation of the screenshot
    func submitFeedbackScreenshot(id: String, signature: String, screenshot: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            let chunkSize = 31250
            let stringChunks = screenshot.components(withLength: chunkSize)
            if stringChunks.count == 0 {
                reject(NSError(domain: "invalid screenshot", code: 0, userInfo: nil))
                return
            }
            var promisedSucceeded = 0

            for (index, chunk) in stringChunks.enumerated() {
                createPromise(id: id, signature: signature, v: index + 1, screenshot: chunk).then { _ in
                    promisedSucceeded += 1
                    if promisedSucceeded == stringChunks.count {
                        self.closeTheDeal(id: id, signature: signature, v: stringChunks.count + 1).then { _ in
                            PLog("Deal closed")
                            fulfill(true)
                        }.catch { err in
                            reject(err)
                            PLog(err)
                        }
                    }
                }.catch { err in
                    PLog(err)
                    reject(err)
                }
            }
        }
    }

    func closeTheDeal(id: String, signature: String, v: Int) -> Promise<Bool> {
        var contentDictionary: [String: Any] = [:]
        contentDictionary["media"] = ["screenshot": ""]

        var payload: [String: Any] = [:]

        payload["id"] = id
        payload["sig"] = signature
        payload["type"] = "app_feedback"
        payload["subtype"] = "media.screenshot"
        payload["v"] = NSNumber(value: v)
        payload["done"] = true
        payload["data"] = contentDictionary

        return Promise { fulfill, reject in
            let headersData: [String: String] = [:]
            httpClient.request(requestBuilder.submitUrl, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headersData, responseQueue: nil, allowNilData: false) { response in
                if response.success {
                    fulfill(true)
                    return
                }
                guard let error = response.error else {
                    PLog("❌ error missing from response")
                    reject(NSError(domain: "error missing from response", code: 0, userInfo: nil))
                    return
                }
                reject(error)
            }
        }
    }

    func createPromise(id: String, signature: String, v: Int, screenshot: String) -> Promise<Bool> {

        var contentDictionary: [String: Any] = [:]
        contentDictionary["media"] = ["screenshot": screenshot]
        var payload: [String: Any] = [:]

        payload["id"] = id
        payload["sig"] = signature
        payload["type"] = "app_feedback"
        payload["subtype"] = "media.screenshot"
        payload["v"] = NSNumber(value: Int32(v))
        payload["done"] = false
        payload["data"] = contentDictionary

        return Promise { fulfill, reject in
            let headersData: [String: String] = [:]
            httpClient.request(self.requestBuilder.submitUrl, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headersData, responseQueue: nil, allowNilData: true) { response in
                if response.success {
                    fulfill(true)
                    return
                }
                guard let error = response.error else {
                    PLog("❌ error missing from response")
                    reject(NSError(domain: "error missing from response", code: 0, userInfo: nil))
                    return
                }
                reject(error)
            }
        }

    }

    /// Submits form data without screenshot (Only text)
    ///
    /// - Parameter payload: data to submit
    /// - Returns: Promise containig the responde data from the widget server
    func submitFeedbackSmallData(payload: [String: Any]) -> Promise<HTTPClientResponse> {
        return Promise { fulfill, reject in
            let headersData: [String: String] = [:]
            httpClient.request(requestBuilder.submitUrl, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headersData, responseQueue: nil, allowNilData: false) { response in
                if response.success {
                    fulfill(response)
                    return
                }
                guard let error = response.error else {
                    PLog("❌ error missing from response")
                    reject(NSError(domain: "error missing from response", code: 0, userInfo: nil))
                    return
                }
                reject(error)
            }
        }
    }
}
