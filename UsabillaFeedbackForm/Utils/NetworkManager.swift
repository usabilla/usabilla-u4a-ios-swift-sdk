//
//  NetworkManager.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 31/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire


class NetworkManager {
    
    
    
    static let bundle =  Bundle(for: NetworkManager.self)
    static let api_url = bundle.infoDictionary!["USABILLA_API_URL"] as! String
    static let submit_url = bundle.infoDictionary!["USABILLA_SUBMIT_ENDPOINT"] as! String
    
    
    
    /// Gets the json of the corrisponding form ID from the Usabilla API
    ///
    /// - Parameter formID: ID of the form
    /// - Returns: Promise containing the JSON description of the form, error if form not found
    class func getFormWithFormID(formID: String) -> Promise<JSON> {
        
        let headers: [String: String]? = [
            "app-version": Bundle.main.infoDictionary!["CFBundleVersion"] as! String,
            "app-name": Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String,
            "sdk-version": Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
            "os": "iOS"
        ]
        
        
        let request_url = String(format: "https://%@/live/mobile/app/forms/%@", arguments: [api_url, formID])
        return Promise { fulfill, reject in
            
            Alamofire.request(request_url, headers: headers)
                .responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        fulfill(JSON(response.result.value!))
                    case .failure:
                        return reject(NSError(domain: "Invalid Request", code: 0, userInfo: [:]))
                    }
            }
            
        }
        
    }
    
    
    
    /// Submits the form results to usabilla
    ///
    /// - Parameters:
    ///   - payload: Payload containing the user data
    ///   - screenshot: self explanatory screenshot
    class func submitFormToUsabilla (payload: [String:Any], screenshot: String?) {
        
        
        submitFeedbackSmallData(payload: payload).then { (response: DataResponse<Any>) -> () in
            
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let id = json["id"].stringValue
                let signature = json["sig"].stringValue
                if let screenshot = screenshot {
                    submitFeedbackScreenshot(id: id, signature: signature, screenshot: screenshot)
                }
                break
            default :
                print("Request failed with error: \(response.response?.statusCode)")
                break
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
        contentDictionary["media"] = ["screenshot" : ""]
        
        var payload: [String: Any] = [:]
        
        payload["id"] = id
        payload["sig"] = signature
        payload["type"] = "app_feedback"
        payload["subtype"] = "media.screenshot"
        payload["v"] = NSNumber(value: v)
        payload["done"] = true
        payload["data"] = contentDictionary
        
        return Promise { fulfill, reject in
            
            Alamofire.request(submit_url, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: nil)
                .responseJSON {response in
                    switch response.result {
                    case .success:
                        fulfill(true)
                    case .failure:
                        return reject(NSError(domain: "Invalid response", code: 0, userInfo: [:]))
                    }
            }
        }
        
        
    }
    
    class func createPromise(id: String, signature: String, v: Int, screenshot: String) -> Promise<Bool> {
        
        var contentDictionary: [String: Any] = [:]
        contentDictionary["media"] = ["screenshot" : screenshot]
        var payload: [String: Any] = [:]
        
        payload["id"] = id
        payload["sig"] = signature
        payload["type"] = "app_feedback"
        payload["subtype"] = "media.screenshot"
        payload["v"] = NSNumber(value: Int32(v))
        payload["done"] = false
        payload["data"] = contentDictionary
        
        
        
        return Promise { fulfill, reject in
            
            Alamofire.request(submit_url, method: HTTPMethod.post, parameters: payload, encoding:  JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(_):
                        fulfill(true)
                        
                    case .failure(_):
                        return reject(NSError(domain: "Invalid FormID", code: 0, userInfo: [:]))
                    }
            }
        }
        
    }
    
    
    /// Submits form data without screenshot (Only text)
    ///
    /// - Parameter payload: data to submit
    /// - Returns: Promise containig the responde data from the widget server
    class func submitFeedbackSmallData(payload: [String:Any])  -> Promise<DataResponse<Any>> {
        return Promise { fulfill, reject in
            
            Alamofire.request(submit_url, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        fulfill(response)
                    case .failure:
                        return reject(NSError(domain: "Invalid FormID", code: 0, userInfo: [:]))
                    }
                    
            }
        }
    }
}
