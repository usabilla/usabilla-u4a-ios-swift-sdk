//
//  UBCampaignFeedbackRequestDAO.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 14/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class UBCampaignFeedbackRequestDAO: UBFileStorageDAO<UBCampaignFeedbackRequest> {
    static let directory = FileDirectory.campaignFeedbackRequest
    static let shared = UBCampaignFeedbackRequestDAO()

    required init() {
        super.init(directory: UBCampaignFeedbackRequestDAO.directory)
    }

    override func id(forObj: UBCampaignFeedbackRequest) -> String {
        return forObj.id
    }

    override func readAll() -> [UBCampaignFeedbackRequest] {
        return super.readAll().sorted { $0.id < $1.id}
    }
}
