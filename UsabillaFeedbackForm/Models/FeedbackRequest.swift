//
//  FeedbackRequest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

struct FeedbackRequest {
    var payload: [String: Any]
    var screenshot: String?

    init(payload: [String: Any], screenshot: String?){
        self.payload = payload
        self.screenshot = screenshot
    }
    
    func encode()->[String: AnyObject] {
        var data = [String: AnyObject]()
        data["payload"] = payload as? AnyObject
        if screenshot != nil {
            data["screenshot"] = screenshot as AnyObject
        }
        return data
    }

    init(data: [String: AnyObject]){
        payload = data["payload"] as?  [String: Any] ?? [:]
        screenshot = data["screenshot"] as? String
    }
}
