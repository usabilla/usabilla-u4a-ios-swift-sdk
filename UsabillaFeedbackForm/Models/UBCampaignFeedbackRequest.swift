//
//  UBCampaignFeedbackRequest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBCampaignFeedbackRequest: NSObject, NSCoding {
    let request: URLRequest
    let id: String
    var numberOfSubmissionAttempts: Int = 0

    init(request: URLRequest, id: String = Int64(Date().timeIntervalSince1970 * 1000).description, numberOfSubmissionAttempts: Int = 0) {
        self.request = request
        self.id = id
        self.numberOfSubmissionAttempts = numberOfSubmissionAttempts
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        guard let request = aDecoder.decodeObject(forKey: "request") as? URLRequest,
            let id = aDecoder.decodeObject(forKey: "id") as? String else {
                PLog("❌ impossible to decode UBCampaignFeedbackRequest")
                return nil
        }
        self.request = request
        self.id = id
        self.numberOfSubmissionAttempts = aDecoder.decodeInteger(forKey: "numberOfTries")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(request, forKey: "request")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(numberOfSubmissionAttempts, forKey: "numberOfTries")
    }
}
