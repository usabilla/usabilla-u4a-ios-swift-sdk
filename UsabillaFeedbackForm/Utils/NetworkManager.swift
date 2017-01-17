//
//  NetworkManager.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 31/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import PromiseKit

struct HTTPClientResponse {
    let data: Any?
    let error: NSError?
    let success: Bool
}

class HTTPClient {

    class func request(request: URLRequest, completion: @escaping (HTTPClientResponse) -> ()) {

        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            debugPrint(response)

            guard error == nil else {
                completion(HTTPClientResponse(data: nil, error: NSError(domain: error.debugDescription, code: 0, userInfo: nil), success: false))
                return
            }
            guard let data = data else {
                completion(HTTPClientResponse(data: nil, error: NSError(domain: "No reponse Data", code: 1, userInfo: nil), success: false))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                debugPrint(json)
                completion(HTTPClientResponse(data: json, error: nil, success: true))
            }
            catch {
                completion(HTTPClientResponse(data: nil, error: NSError(domain: "Invalid JSON", code: 2, userInfo: nil), success: false))
            }
        }
        task.resume()
    }

}

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
            let request = NSMutableURLRequest(url: URL(string: request_url)!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            HTTPClient.request(request: request as URLRequest) { response in
                if response.success {
                    fulfill(JSON(response.data))
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

    class func submitFormToUsabilla(payload: [String: Any], screenshot: String?) {
        submitFeedbackSmallData(payload: payload).then { response -> Void in
            let json = JSON(response.data)
            let id = json["id"].stringValue
            let signature = json["sig"].stringValue
            if let screenshot = screenshot {
                submitFeedbackScreenshot(id: id, signature: signature, screenshot: screenshot)
            }
        }.catch { error in
            print(error)
        }
    }


    /// Submits the screenshot as a separate request
    ///
    /// - Parameters:
    ///   - id: ID of the data that the screenshot must be added to. (Widget server data)
    ///   - signature: Same as ID
    ///   - screenshot: base64 representation of the screenshot
    class func submitFeedbackScreenshot(id: String, signature: String, screenshot: String) {
        let chuckSize = 31250
        var promiseArray: [Promise<Bool>] = []
        let stringChunks = screenshot.divideInChunksOfSize(chuckSize)

        for (index, chunk) in stringChunks.enumerated() {
            promiseArray.append(createPromise(id: id, signature: signature, v: index + 1, screenshot: chunk))
        }

        when(resolved: promiseArray).then { _ in
            closeTheDeal(id: id, signature: signature, v: stringChunks.count + 1)
        }.catch { error in
            print(error)
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
            let request = NSMutableURLRequest(url: URL(string: submitUrl)!)
            request.httpMethod = "POST"
            let data = try JSONSerialization.data(withJSONObject: payload)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            HTTPClient.request(request: request as URLRequest) { response in
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
            let request = NSMutableURLRequest(url: URL(string: submitUrl)!)
            request.httpMethod = "POST"
            let data = try JSONSerialization.data(withJSONObject: payload)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            HTTPClient.request(request: request as URLRequest) { response in
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
            let request = NSMutableURLRequest(url: URL(string: submitUrl)!)
            request.httpMethod = "POST"
            let data = try JSONSerialization.data(withJSONObject: payload)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            HTTPClient.request(request: request as URLRequest) { response in
                if response.success {
                    fulfill(response)
                    return
                }
                reject(response.error!)
            }
        }
    }

    ///Stuff moved to be private

    class func getFormJsonFromServer(_ appId: String, screenshot: UIImage?, customVariables: [String: Any]?, themeConfig: UsabillaThemeConfigurator) {

        getFormWithFormID(formID: appId).then(on: DispatchQueue.global(qos: .background), execute: { (jsonObj: JSON) -> Void in
            let form: FormModel = JSONFormParser.parseFormJson(jsonObj, appId: appId, screenshot: screenshot, themeConfig: themeConfig)

            let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
            guard let base = storyboard.instantiateViewController(withIdentifier: "base") as? UINavigationController,
                let formController = base.childViewControllers[0] as? FormViewController else {
                    return
            }


            formController.initWithFormModel(form)
            formController.customVars = customVariables
            Swift.debugPrint("calling success protocol")

            DispatchQueue.main.async {
                UsabillaFeedbackForm.delegate?.formLoadedCorrectly(base, active: true)
            }
        })
            .catch { _ in
                Swift.debugPrint("calling fail protocol")
                UsabillaFeedbackForm.delegate?.formFailedLoading(loadDefaultForm(appId, screenshot: screenshot, customVariables: customVariables, themeConfig: themeConfig)!)
        } }


    class func loadDefaultForm(_ appId: String, screenshot: UIImage?, customVariables: [String: Any]?, themeConfig: UsabillaThemeConfigurator) -> UINavigationController? {
        if let path = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.path(forResource: "defaultJson", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)

                let jsonObj: JSON = JSON(data: data)
                if jsonObj != JSON.null {
                    let form: FormModel = JSONFormParser.parseFormJson(jsonObj, appId: appId, screenshot: screenshot, themeConfig: themeConfig)
                    form.isDefault = true
                    let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
                    let base = storyboard.instantiateViewController(withIdentifier: "base") as? UINavigationController
                    let formController = base?.childViewControllers[0] as? FormViewController

                    formController!.initWithFormModel(form)
                    formController!.customVars = customVariables

                    return base!

                } else {
                    Swift.debugPrint("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }
        } else {
            Swift.debugPrint("Invalid filename/path.")
        }
        return nil
    }
}
