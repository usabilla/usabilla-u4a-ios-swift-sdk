//
//  UBCampaignFeedbackRequest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class UBCampaignFeedbackRequest: NSObject, NSCoding {
    let request: URLRequest
    let id: String
    var numberOfTries: Int

    init(request: URLRequest, id: String = Int64(Date().timeIntervalSince1970 * 1000).description, numberOfTries: Int = 0) {
        self.request = request
        self.id = id
        self.numberOfTries = numberOfTries
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        self.request = (aDecoder.decodeObject(forKey: "request") as? URLRequest)!
        self.id = (aDecoder.decodeObject(forKey: "id") as? String)!
        self.numberOfTries = aDecoder.decodeInteger(forKey: "numberOfTries")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(request, forKey: "request")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(numberOfTries, forKey: "numberOfTries")
    }
}
