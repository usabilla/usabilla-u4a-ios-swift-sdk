//
//  NetworkManager.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 31/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class NetworkManager {

    static let bundle = Bundle(for: NetworkManager.self)
    static let apiUrl = bundle.infoDictionary!["USABILLA_API_URL"] as? String ?? ""
    static let submitUrl = bundle.infoDictionary!["USABILLA_SUBMIT_ENDPOINT"] as? String ?? ""

    /// Gets the json of the corrisponding form ID from the Usabilla API
    ///
    /// - Parameter formID: ID of the form
    /// - Returns: Promise containing the JSON description of the form, error if form not found
    class func getFormWithFormID(formID: String) -> Promise<JSON> {

        let headers: [String: String]? = [
            "app-version": Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "",
            "app-name": Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? "",
            "sdk-version": Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
            "os": "iOS"
        ]

        let request_url = String(format: "https://%@/live/mobile/app/forms/%@", arguments: [apiUrl, formID])

        return Promise { fulfill, reject in
            HTTPClient.request(request_url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers) { response in
                if response.success {
                    guard let data = response.data else {
                        return
                    }
                    fulfill(JSON(data))
                    return
                }
                reject(response.error!)
            }
        }
    }

    /// Submits the form results to usabilla
    ///
    /// - Parameters:
    ///   - payload: Payload containing the user data
    ///   - screenshot: self explanatory screenshot

    class func submitFormToUsabilla(payload: [String: Any], screenshot: String?) -> Promise<Bool> {
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
                    submitFeedbackScreenshot(id: id, signature: signature, screenshot: screenshot).then { _ in
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
    class func submitFeedbackScreenshot(id: String, signature: String, screenshot: String) -> Promise<Bool> {
        return Promise { fulfill, reject in

            let chuckSize = 31250
            let stringChunks = screenshot.divideInChunksOfSize(chuckSize)
            if stringChunks.count == 0 {
                reject(NSError(domain: "invalid screenshot", code: 0, userInfo: nil))
                return
            }
            var promisedSucceeded = 0

            for (index, chunk) in stringChunks.enumerated() {
                createPromise(id: id, signature: signature, v: index + 1, screenshot: chunk).then(execute: { _ in
                    promisedSucceeded += 1
                    if promisedSucceeded == stringChunks.count {
                        closeTheDeal(id: id, signature: signature, v: stringChunks.count + 1).then(execute: { _ in
                            PLog("Deal closed")
                            fulfill(true)
                        }).catch { err in
                            reject(err)
                            PLog(err)
                        }
                    }
                }).catch(execute: { err in
                    PLog(err)
                })
            }
        }
    }

    class func closeTheDeal(id: String, signature: String, v: Int) -> Promise<Bool> {
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
            HTTPClient.request(submitUrl, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: nil) { response in
                if response.success {
                    fulfill(true)
                    return
                }
                reject(response.error!)
            }
        }
    }

    class func createPromise(id: String, signature: String, v: Int, screenshot: String) -> Promise<Bool> {

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
            HTTPClient.request(submitUrl, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: nil) { response in
                if response.success {
                    fulfill(true)
                    return
                }
                reject(response.error!)
            }
        }

    }

    /// Submits form data without screenshot (Only text)
    ///
    /// - Parameter payload: data to submit
    /// - Returns: Promise containig the responde data from the widget server
    class func submitFeedbackSmallData(payload: [String: Any]) -> Promise<HTTPClientResponse> {
        return Promise { fulfill, reject in
            HTTPClient.request(submitUrl, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: nil) { response in
                if response.success {
                    fulfill(response)
                    return
                }
                reject(response.error!)
            }
        }
    }

    /**
        getForm : loads a form with id from network and returns a FormModel object of it to be used
 
        @parameter formId: the form id
        @return Pormise<FormModel> : a promess of a valid form model
     */
    class func getForm(_ appId: String, screenshot: UIImage?, customVariables: [String: Any]?, theme: UsabillaTheme) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            getFormWithFormID(formID: appId).then { (jsonObj: JSON) -> Void in
                let form = FormModel(json: jsonObj, id: appId, screenshot: screenshot)
                PLog("form loaded successfully")
                fulfill(form)
            }.catch { error in
                PLog("form couldn't load")
                reject(error)
            }
        }
    }
}
