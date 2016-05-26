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
import SwiftyJSON


class NetworkManager {
    
    
    static let bundle = NSBundle(forClass: NetworkManager.self)
    static let api_url = bundle.infoDictionary!["USABILLA_API_URL"] as! String
    static let submit_url = bundle.infoDictionary!["USABILLA_SUBMIT_ENDPOINT"] as! String
    
    class func getFromFromID(formID: String) -> Promise<JSON> {
        
        let request_url = String(format: "https://%@/live/mobile/app/forms/%@", arguments: [api_url, formID])
        return Promise { fulfill, reject in
            
            Alamofire.request(.GET, request_url)
                .response { (request, response, json, error) in
                    let statusCode = response!.statusCode
                    
                    if error != nil {
                        return reject(error!)
                    }
                    
                    if statusCode < 200 || statusCode > 299 {
                        return reject(NSError(domain: "Invalid FormID", code: statusCode, userInfo: [:]))
                    }
                    
                    let json = JSON(data: json!)
                    fulfill(json)
            }
            
        }
        
    }
    
    class func submitFormToUsabilla (payload: [String:AnyObject], screenshot: String?) {
        
        submitFeedbackSmallData(payload).then { (response: Response<AnyObject, NSError>?) -> () in
            
            if let response = response {
                switch response.result {
                case .Success( _):
//                    let json = JSON(data)
//                    let id = json["id"].stringValue
//                    let signature = json["sig"].stringValue
//                    if let screenshot = screenshot {
//                        submitFeedbackScreenshot(id, signature: signature, screenshot: screenshot)
//                    }
                    break
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
            
        }
        
        
    }
    
    
    class func submitFeedbackScreenshot(id: String, signature: String, screenshot: String) {
        let chuckSize = 31250
        var promiseArray: [Promise<Bool>] = []
        let stringChunks = screenshot.divideInChunksOfSize(chuckSize)
        
        for (index, chunk) in stringChunks.enumerate() {
            promiseArray.append(createPromise(id, signature: signature, v: index + 1, screenshot: chunk))
        }
        
        when(promiseArray).then { _ -> () in
            closeTheDeal(id, signature: signature, v: stringChunks.count + 1)
        }
        
    }
    
    class func closeTheDeal(id: String, signature: String, v: Int) -> Promise<Bool> {
        let contentDictionary: [String: AnyObject] = [:]
        
        var payload: [String: AnyObject] = [:]
        
        payload["id"] = id
        payload["sig"] = signature
        payload["type"] = "app_feedback"
        payload["subtype"] = "media.screenshot"
        payload["v"] = NSNumber(int: Int32(v))
        payload["done"] = true
        payload["data"] = contentDictionary
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, submit_url, parameters: payload, encoding: .JSON)
                .response {request, response, data, error in
                    let statusCode = response!.statusCode
                    if error != nil {
                        return reject(error!)
                    }
                    
                    if statusCode < 200 || statusCode > 299 {
                        return reject(NSError(domain: "Invalid FormID", code: statusCode, userInfo: [:]))
                    }
                    fulfill(true)
            }
        }
        
        
    }
    
    class func createPromise(id: String, signature: String, v: Int, screenshot: String) -> Promise<Bool> {
        
        var contentDictionary: [String: AnyObject] = [:]
        contentDictionary["media"] = ["screenshot" : screenshot]
        var payload: [String: AnyObject] = [:]
        
        payload["id"] = id
        payload["sig"] = signature
        payload["type"] = "app_feedback"
        payload["subtype"] = "media.screenshot"
        payload["v"] = NSNumber(int: Int32(v))
        payload["done"] = false
        payload["data"] = contentDictionary
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, submit_url, parameters: payload, encoding: .JSON)
                .response {request, response, data, error in
                    let statusCode = response!.statusCode
                    if error != nil {
                        return reject(error!)
                    }
                    
                    if statusCode < 200 || statusCode > 299 {
                        return reject(NSError(domain: "Invalid FormID", code: statusCode, userInfo: [:]))
                    }
                    
                    fulfill(true)
            }
        }
        
    }
    
    
    class func submitFeedbackSmallData(payload: [String:AnyObject])  -> Promise<Response<AnyObject, NSError>> {
        return Promise { fulfill, reject in
            Alamofire.request(.POST, submit_url, parameters: payload, encoding: .JSON)
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                    fulfill(response)
            }
        }
    }
}
