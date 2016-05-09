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
    
    class func submitFormToUsabilla (payload: [String:AnyObject]) -> Promise<Bool> {
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, submit_url, parameters: payload, encoding: .JSON)
                .response { (request, response, json, error) in
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
}
