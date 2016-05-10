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
        print("calling network form getter")
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
    
    class func submitFormToUsabilla ( payload: [String:AnyObject], screenshot: String?){
        
        //contentDictionary["media"] = ["screenshot" : screenshot]
        submitFeedbackSmallData(payload).then{ (response : Response<AnyObject, NSError>?) -> () in
            print(response)
            if let response = response {
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    let id = json["id"].stringValue
                    let signature = json["sig"].stringValue
                    if let screenshot = screenshot {
                        submitFeedbackScreenshot(id, signature: signature, screenshot: screenshot)
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
            
        }
        
        
    }
    
    
    class func submitFeedbackScreenshot(id: String, signature: String, screenshot: String){
        let chuckSize = 31250
        var promiseArray: [Promise<Bool>] = []
        //let screenshotArray = Array(screenshot.characters)
        let screenshotCharacterCount = screenshot.characters.count
        let numberOfChunks = screenshotCharacterCount / chuckSize
        let lastChunk = screenshotCharacterCount % chuckSize
        print("last fucking chunk \(lastChunk)")
        
        if numberOfChunks > 0{
            for chunk in 0...numberOfChunks - 1 {
                let start = chunk * chuckSize
                //let end = (chunk+1) * chuckSize
                let range = NSRange(location: start, length:  chuckSize)
                let screenshotSection = (screenshot as NSString).substringWithRange(range)
                promiseArray.append(createPromise(id, signature: signature, v: chunk + 1, screenshot: screenshotSection))
                
            }
        }
        if lastChunk > 0 {
            let lastRange = NSRange(location: numberOfChunks*chuckSize, length:  lastChunk)
            let screenshotSection = (screenshot as NSString).substringWithRange(lastRange)
            promiseArray.append(createPromise(id, signature: signature, v: numberOfChunks, screenshot: screenshotSection))
            
        }
        
        when(promiseArray).then { _ -> () in
            print("closing deal")
            closeTheDeal(id, signature: signature, v: numberOfChunks + 1).then
                { _ in
                    print("success!")
                    
            }
            }.error { error in
                print("when failder")
        }
        
        
    }
    
    class func closeTheDeal(id:String, signature:String, v: Int) -> Promise<Bool> {
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
                    print(request)
                    print(response)
                    print(data)
                    print(error)
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
    
    class func createPromise(id:String, signature:String, v: Int, screenshot: String) -> Promise<Bool> {
        
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
                    print("promise number \(v) fulfilled")

                    fulfill(true)
            }
        }
        
    }
    
    
    class func submitFeedbackSmallData(payload: [String:AnyObject])  -> Promise<Response<AnyObject, NSError>> {
        return Promise { fulfill, reject in
            Alamofire.request(.POST, submit_url, parameters: payload, encoding: .JSON)
                .responseJSON { response in
                    //                    let statusCode = response!.statusCode
                    //                    
                    //                    if error != nil {
                    //                        return reject(error!)
                    //                    }
                    //                    
                    //                    if statusCode < 200 || statusCode > 299 {
                    //                        return reject(NSError(domain: "Invalid FormID", code: statusCode, userInfo: [:]))
                    //                    }
                    fulfill(response)
            }
        }
    }
}
