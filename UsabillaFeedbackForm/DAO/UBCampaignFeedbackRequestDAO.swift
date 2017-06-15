//
//  UBCampaignFeedbackRequestDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 14/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class UBCampaignFeedbackRequest: NSObject, NSCoding {
    var items: [UBCampaignFeedbackRequestItem]
    let id: String

    init(id: String, items: [UBCampaignFeedbackRequestItem] = []) {
        self.id = id
        self.items = items
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        self.id = (aDecoder.decodeObject(forKey: "id") as? String)!
        self.items = (aDecoder.decodeObject(forKey: "items") as? [UBCampaignFeedbackRequestItem])!
        // swiftlint:disable:next force_cast
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(items, forKey: "items")
    }
}

class UBCampaignFeedbackRequestItem: NSObject, NSCoding {
    let request: URLRequest
    let feedbackId: String
    let type: RequestType

    init(request: URLRequest, feedbackId: String, type: RequestType) {
        self.request = request
        self.feedbackId = feedbackId
        self.type = type
    }

    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        self.request = (aDecoder.decodeObject(forKey: "request") as? URLRequest)!
        self.feedbackId = (aDecoder.decodeObject(forKey: "feedbackId") as? String)!
        // swiftlint:disable:next force_cast
        self.type = RequestType(rawValue: (aDecoder.decodeObject(forKey: "type") as! String))!
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(request, forKey: "request")
        aCoder.encode(feedbackId, forKey: "feedbackId")
        aCoder.encode(type.rawValue, forKey: "type")
    }
}

class UBCampaignFeedbackRequestDAO: UBFileStorageDAO<UBCampaignFeedbackRequest> {
    static let directoryName = "UBCampaignFeedbackRequest"
    static let shared = UBCampaignFeedbackRequestDAO()

    internal required init() {
        super.init(directoryName: UBCampaignFeedbackRequestDAO.directoryName)
    }

    override func id(forObj: UBCampaignFeedbackRequest) -> String {
        return forObj.id
    }
}
