//
//  UBCampaignFeedbackRequest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBCampaignFeedbackRequest: NSObject, NSCoding {

    private struct Archiving {
        static let request = "request"
        static let id = "id"
        static let localID = "localID"
        static let numberOfSubmissionAttempts = "numberOfSubmissionAttempts"
    }

    let request: URLRequest
    let id: String
    let internalID: String
    var numberOfSubmissionAttempts: Int = 0

    init(request: URLRequest, internalID: String, id: String = Int64(Date().timeIntervalSince1970 * 1000).description, numberOfSubmissionAttempts: Int = 0) {
        self.request = request
        self.id = id
        self.numberOfSubmissionAttempts = numberOfSubmissionAttempts
        self.internalID = internalID
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        guard let request = aDecoder.decodeObject(forKey: Archiving.request) as? URLRequest,
            let internalID = aDecoder.decodeObject(forKey: Archiving.localID) as? String,
            let id = aDecoder.decodeObject(forKey: Archiving.id) as? String else {
                PLog("❌ impossible to decode UBCampaignFeedbackRequest")
                return nil
        }
        self.request = request
        self.id = id
        self.numberOfSubmissionAttempts = aDecoder.decodeInteger(forKey: Archiving.numberOfSubmissionAttempts)
        self.internalID = internalID
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(request, forKey: Archiving.request)
        aCoder.encode(id, forKey: Archiving.id)
        aCoder.encode(internalID, forKey: Archiving.localID)
        aCoder.encode(numberOfSubmissionAttempts, forKey: Archiving.numberOfSubmissionAttempts)
    }
}
